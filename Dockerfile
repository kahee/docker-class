FROM        ec2-deploy:base

# Copy project files
COPY        .   /srv/project
WORKDIR     /srv/project

RUN         export VENV_PATH=$(pipenv --venv); echo $VENV_PATH;
CMD         pipenv run uwsgi \
                --http :8000 \
                --chdir /srv/project/app \
                --module config.wsgi