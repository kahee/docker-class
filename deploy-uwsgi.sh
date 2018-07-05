#!/usr/bin/env bash
# 실행 시 서버에서 이미 실행중이던 uwsgi프로세스들을 모두 종료하고
# 기존루틴 실행
# 이후 runserver대신 uwsgi를 실행 (ini파일을 사용)

IDENTITY_FILE="$HOME/.ssh/fc-8th.pem"
USER="ubuntu"
HOST="ec2-13-124-176-99.ap-northeast-2.compute.amazonaws.com"
PROJECT_DIR="$HOME/projects/fastcampus/lecture-8th/deploy/ec2-deploy"
SERVER_DIR="/home/ubuntu/project"
# ssh로 서버에 접속하는 명령어
CMD_CONNECT="ssh -i ${IDENTITY_FILE} ${USER}@${HOST}"

echo "Start deploy"

# 서버에서 실행중이던 runserver 프로세스들을 모두 종료
${CMD_CONNECT} "pkill -9 -ef runserver"
echo "- Kill runserver processes"

# 서버의 파일을 지움
${CMD_CONNECT} rm -rf ${SERVER_DIR}
echo "- Delete server files"

# 서버에 프로젝트 파일을 다시 업로드
scp -q -i ${IDENTITY_FILE} -r ${PROJECT_DIR} ${USER}@${HOST}:${SERVER_DIR}
echo "- Upload files"

# 서버 접속 후 SERVER_DIR로 이동, pipenv --venv로 가상환경의 경로 가져오기
VENV_PATH=$(${CMD_CONNECT} "cd ${SERVER_DIR} && pipenv --venv")
# 가상환경의 경로에 /bin/python을 붙여 서버에서 사용하는 python의 경로 만들기
PYTHON_PATH="${VENV_PATH}/bin/python"
echo "- Get Python path ($PYTHON_PATH)"

# runserver를 background에서 실행해주는 커맨드 (nohup)
RUNSERVER_CMD="nohup ${PYTHON_PATH} manage.py runserver 0:8000 &>/dev/null &"
# 서버 접속 후, 프로젝트의 'app'폴더까지 이동한 후 runserver명령어를 실행
${CMD_CONNECT} "cd ${SERVER_DIR}/app && ${RUNSERVER_CMD}"
echo "- Execute runserver"

echo "Deploy complete"


