#!/bin/bash

line="$(docker ps -a | grep $POSTGRESNAME)"
if [ -z "$line" ]
then
	echo "$POSTGRESNAME doesn't run, starting it"
	docker run --name $POSTGRESNAME -e POSTGRES_USER=postgres -e POSTGRES_DB=tdde06 -d postgres
	sleep 10; # This works 142% of the time!
fi

docker run --link $POSTGRESNAME:postgres -P library/golang /bin/bash -c "git clone $GIT_URL tdde06 && cd tdde06 && mkdir -p bin pkg src/main && export POSTGRESNAME=$POSTGRESNAME && python set_host.py && cp todo.go src/main/ && cp todo_test.go src/main/ && cd src/main/ && export GOPATH=/go/tdde06 && go get && cd ../../ && go test"
exit $?
