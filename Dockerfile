FROM openjdk:8
ADD demo-workshop.jar ttrend.jar 
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]