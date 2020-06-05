FROM python
WORKDIR /curriculum
COPY ./requirements.txt .
RUN pip install -r requirements.txt
RUN apt update -y && apt install inotify-tools -y
CMD [ "bash", "watch-build.sh" ]