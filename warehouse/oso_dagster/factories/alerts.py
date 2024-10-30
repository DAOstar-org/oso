from dagster import (
    DefaultSensorStatus,
    OpExecutionContext,
    RunConfig,
    RunFailureSensorContext,
    RunRequest,
    job,
    op,
    run_failure_sensor,
)

from ..utils import AlertManager, AlertOpConfig
from .common import AssetFactoryResponse


def setup_alert_sensor(name: str, base_url: str, alert_manager: AlertManager):
    @op(name=f"{name}_alert_op")
    def failure_op(context: OpExecutionContext, config: AlertOpConfig) -> None:
        alert_manager.failure_op(base_url, context, config)

    @job(name=f"{name}_alert_job")
    def failure_job():
        failure_op()

    @run_failure_sensor(
        name=name, default_status=DefaultSensorStatus.RUNNING, request_job=failure_job
    )
    def failure_sensor(context: RunFailureSensorContext):
        yield RunRequest(
            tags={
                "dagster-k8s/config": {
                    "merge_behavior": "SHALLOW",
                    "container_config": {
                        "resources": {
                            "requests": {
                                "cpu": "500m",
                                "memory": "768Mi",
                            },
                            "limits": {
                                "cpu": "500m",
                                "memory": "1536Mi",
                            },
                        },
                    },
                    "pod_spec_config": {
                        "node_selector": {
                            "pool_type": "persistent",
                        },
                        "tolerations": [
                            {
                                "key": "pool_type",
                                "operator": "Equal",
                                "value": "persistent",
                                "effect": "NoSchedule",
                            }
                        ],
                    },
                },
            },
            run_key=context.dagster_run.run_id,
            run_config=RunConfig(
                ops={
                    f"{name}_alert_op": {
                        "config": {
                            "run_id": context.dagster_run.run_id,
                        }
                    }
                }
            ),
        )

    return AssetFactoryResponse([], sensors=[failure_sensor], jobs=[failure_job])
