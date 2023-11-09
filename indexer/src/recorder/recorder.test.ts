import { DateTime } from "luxon";
import { EventRepository } from "../db/events.js";
import {
  ArtifactNamespace,
  ArtifactType,
  EventType,
  EventTypeEnum,
  RecorderTempDuplicateEvent,
  RecorderTempEvent,
  Recording,
} from "../db/orm-entities.js";
import { withDbDescribe } from "../db/testing.js";
import { BatchEventRecorder, IFlusher } from "./recorder.js";
import {
  IncompleteEvent,
  RecordHandle,
  generateEventTypeStrategy,
} from "./types.js";
import { AppDataSource } from "../db/data-source.js";
import { randomInt, randomUUID } from "node:crypto";
import _ from "lodash";

type Callback = () => void;

class TestFlusher implements IFlusher {
  flushCallback: Callback | undefined;
  lastNotify: number;

  clear(): void {}

  flush(): void {
    if (this.flushCallback) {
      this.flushCallback();
    }
  }

  onFlush(cb: () => void): void {
    this.flushCallback = cb;
  }

  notify(size: number): void {
    this.lastNotify = size;
  }
}

type RandomCommitEventOptions = {
  fromProbability: number;
  repoNameGenerator: () => string;
  usernameGenerator: () => string;
};

function randomCommitEventsGenerator(
  count: number,
  options?: Partial<RandomCommitEventOptions>,
): IncompleteEvent[] {
  const opts: RandomCommitEventOptions = _.merge(
    {
      fromProbability: 1,
      repoNameGenerator: () => `repo-${randomUUID()}`,
      usernameGenerator: () => `user-${randomUUID()}`,
    },
    options,
  );

  const events: IncompleteEvent[] = [];

  for (let i = 0; i < count; i++) {
    const randomToRepoName = opts.repoNameGenerator();
    const randomFromUsername = opts.usernameGenerator();
    const randomTime = DateTime.now()
      .minus({ days: 10 })
      .plus({ minutes: randomInt(14400) });
    const randomSourceId = randomUUID();
    const event: IncompleteEvent = {
      time: randomTime,
      type: {
        version: 1,
        name: "COMMIT_CODE",
      },
      to: {
        type: ArtifactType.GIT_REPOSITORY,
        name: randomToRepoName,
        namespace: ArtifactNamespace.GITHUB,
      },
      sourceId: randomSourceId,
      amount: 1,
      details: {},
    };
    // probabilistically add a from field
    if (Math.random() > 1.0 - opts.fromProbability) {
      event.from = {
        type: ArtifactType.GITHUB_USER,
        name: randomFromUsername,
        namespace: ArtifactNamespace.GITHUB,
      };
    }
    events.push(event);
  }
  return events;
}

withDbDescribe("BatchEventRecorder", () => {
  let flusher: TestFlusher;
  beforeEach(async () => {
    flusher = new TestFlusher();
  });

  it("should setup the recorder", async () => {
    const recorder = new BatchEventRecorder(
      AppDataSource,
      AppDataSource.getRepository(Recording),
      AppDataSource.getRepository(RecorderTempEvent),
      AppDataSource.getRepository(EventType),
      {
        maxBatchSize: 3,
        timeoutMs: 30000,
        flusher: flusher,
      },
    );
    await recorder.loadEventTypes();
    recorder.setRange({
      startDate: DateTime.now().minus({ month: 1 }),
      endDate: DateTime.now().plus({ month: 1 }),
    });
    recorder.registerEventType(
      generateEventTypeStrategy({
        name: "COMMIT_CODE",
        version: 1,
      }),
    );
    recorder.setActorScope(
      [ArtifactNamespace.GITHUB],
      [ArtifactType.GITHUB_USER, ArtifactType.GIT_REPOSITORY],
    );
    const testEvent: IncompleteEvent = {
      amount: Math.random(),
      time: DateTime.now(),
      type: {
        name: "COMMIT_CODE",
        version: 1,
      },
      to: {
        name: "test",
        namespace: ArtifactNamespace.GITHUB,
        type: ArtifactType.GIT_REPOSITORY,
      },
      from: {
        name: "contributor",
        namespace: ArtifactNamespace.GITHUB,
        type: ArtifactType.GITHUB_USER,
      },
      sourceId: "test123",
    };
    const record0Handle = await recorder.record(testEvent);
    flusher.flush();
    await record0Handle.wait();

    // Check that the values are correct
    const results = await EventRepository.find({
      relations: {
        to: true,
        from: true,
        type: true,
      },
      where: {
        type: {
          name: EventTypeEnum.COMMIT_CODE,
        },
      },
    });
    expect(results.length).toEqual(1);
    expect(results[0].sourceId).toEqual(testEvent.sourceId);
    expect(results[0].amount).toEqual(testEvent.amount);
    expect(results[0].to.name).toEqual(testEvent.to.name);
    expect(results[0].to.namespace).toEqual(testEvent.to.namespace);
    expect(results[0].to.type).toEqual(testEvent.to.type);
    expect(results[0].to.id).toBeDefined();
    expect(results[0].from?.name).toEqual(testEvent.from?.name);
    expect(results[0].from?.namespace).toEqual(testEvent.from?.namespace);
    expect(results[0].from?.type).toEqual(testEvent.from?.type);
    expect(results[0].from?.id).toBeDefined();
  });

  describe("various recorder scenarios", () => {
    let recorder: BatchEventRecorder;
    let testEvent: IncompleteEvent;
    beforeEach(async () => {
      recorder = new BatchEventRecorder(
        AppDataSource,
        AppDataSource.getRepository(Recording),
        AppDataSource.getRepository(RecorderTempEvent),
        AppDataSource.getRepository(EventType),
        {
          maxBatchSize: 5000,
          flushIntervalMs: 1000,
          timeoutMs: 60000,
        },
      );
      await recorder.loadEventTypes();
      recorder.setRange({
        startDate: DateTime.now().minus({ month: 1 }),
        endDate: DateTime.now().plus({ month: 1 }),
      });
      recorder.registerEventType(
        generateEventTypeStrategy({
          name: "COMMIT_CODE",
          version: 1,
        }),
      );
      recorder.setActorScope(
        [ArtifactNamespace.GITHUB],
        [ArtifactType.GITHUB_USER, ArtifactType.GIT_REPOSITORY],
      );
      testEvent = {
        amount: Math.random(),
        time: DateTime.now(),
        type: {
          name: "COMMIT_CODE",
          version: 1,
        },
        to: {
          name: "test",
          namespace: ArtifactNamespace.GITHUB,
          type: ArtifactType.GIT_REPOSITORY,
        },
        from: {
          name: "contributor",
          namespace: ArtifactNamespace.GITHUB,
          type: ArtifactType.GITHUB_USER,
        },
        sourceId: "test123",
      };
      const record0Handle = await recorder.record(testEvent);
      flusher.flush();
      await record0Handle.wait();
    });

    afterEach(async () => {
      await recorder.close();
    });

    it("should fail when trying to write a duplicate event", async () => {
      const dupeRepo = AppDataSource.getRepository(RecorderTempDuplicateEvent);

      const dupes = await dupeRepo.find();
      expect(dupes.length).toEqual(1);

      const errs: unknown[] = [];
      recorder.addListener("error", (err) => {
        errs.push(err);
      });

      // An error should be thrown if we attempt to write the same event twice.
      // This should be considered a failure of the collector.
      await recorder.record(testEvent);
      const handle = await recorder.record(randomCommitEventsGenerator(1)[0]);
      await recorder.wait([handle]);

      expect(errs.length).toEqual(1);
    });

    it("should do a large set of writes", async () => {
      const eventCountToWrite = 15000;
      const events = randomCommitEventsGenerator(eventCountToWrite, {
        fromProbability: 0.7,
        repoNameGenerator: () => `repo-${randomInt(100)}`,
      });

      const handles: RecordHandle[] = [];
      for (const event of events) {
        handles.push(await recorder.record(event));
      }
      await recorder.wait(handles);

      // Check that the events are in the database
      const eventCount = await EventRepository.count();
      expect(eventCount).toEqual(eventCountToWrite + 1);
    }, 90000);

    it("should record errors when we write some duplicates over multiple batches", async () => {
      const events = randomCommitEventsGenerator(10);

      const errs: unknown[] = [];

      recorder.addListener("error", (err) => {
        errs.push(err);
      });

      let handles: RecordHandle[] = [];
      for (const event of events) {
        handles.push(await recorder.record(event));
      }
      const results0 = await recorder.wait(handles);
      expect(results0.errors.length).toEqual(0);

      // Add an event for this test to pass
      events.push(...randomCommitEventsGenerator(1));

      // Try to write them again
      handles = [];
      for (const event of events) {
        handles.push(await recorder.record(event));
      }

      await recorder.wait(handles);
      expect(errs.length).toEqual(10);
    });
  });
});
