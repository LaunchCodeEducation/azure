FROM python
WORKDIR /curriculum
COPY . .
RUN pip install -r requirements.txt
RUN apt update -y && apt install inotify-tools -y
CMD [ "bash", "watch-build.sh" ]