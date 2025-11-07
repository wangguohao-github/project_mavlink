#!/bin/bash

usage() {
    echo "Usage: $0 [-i] [-n <docker_name>] [-r <registry>]"
    echo "  options:"
    echo "      -i: initialise buildx and QEMU"
    echo "      -n: docker image name (default: project_mavlink)"
    echo "      -r: docker registry address (default: 128.16.29.85:5000)"
    exit 1
}

# 默认参数
init="false"
name="project_mavlink"
registry="localhost:5000"

# 参数解析
while getopts "in:r:h" opt; do
  case ${opt} in
    i )
      init="true"
      ;;
    n )
      name="${OPTARG}"
      ;;
    r )
      registry="${OPTARG}"
      ;;
    h )
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument" >&2
      usage
      ;;
  esac
done

# 初始化阶段：安装 QEMU + 创建 buildx 构建器
if [[ ${init} == "true" ]]; then
    echo "🛠️  初始化 QEMU 和 Buildx..."
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

    docker buildx create \
        --name container-builder-mavlink \
        --driver docker-container \
        --config config/buildkitd.toml \
        --driver-opt network=host \
        --bootstrap --use || docker buildx use container-builder-mavlink
fi

# 完整镜像名称
# 完整镜像名称
FULL_NAME="${registry}/${name}:latest"

# 构建并推送多架构镜像
docker buildx build \
  --platform linux/amd64,linux/arm64/v8 \
  -t "${FULL_NAME}" \
  -f Dockerfile \
  --push .


# 结果提示
if [[ $? -eq 0 ]]; then
  echo "✅ 构建并推送成功！"
  echo "在树莓派上运行："
  echo "  docker pull ${FULL_NAME}"
  echo "  docker run -it --net=host --privileged ${FULL_NAME}"
else
  echo "❌ 构建失败，请检查日志输出。"
fi
