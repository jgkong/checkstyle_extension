#!/bin/bash

CHECKSTYLE_JAR=${EXT_DIR}/lib/checkstyle-7.8.2-all.jar
CHECKSTYLE_XML='checkstyle_report.xml'
JUNIT_XML='tests/TEST-checkstyle.xml'

shopt -s globstar
java -jar ${CHECKSTYLE_JAR} \
-c /${CONVENTION_STYLE}_checks.xml \
-f xml \
-o "${CHECKSTYLE_XML}" \
"${TARGET}"/**/*.java

if [ $? -gt 0 ]; then
    echo "Error from checkstyle"
    exit 1
fi

if [ ! -f "${CHECKSTYLE_XML}" ]; then
    echo "No results from checkstyle"
    exit
fi

mkdir -p $(dirname ${JUNIT_XML})
python ${EXT_DIR}/checkstyle_to_junit.py ${CHECKSTYLE_XML} ${JUNIT_XML} $(pwd)
