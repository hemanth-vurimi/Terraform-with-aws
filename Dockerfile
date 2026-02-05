FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]


FROM maven:3.8.5-openjdk-17-slim AS build

WORKDIR /app

COPY pom.xml .

RUN mvn clean install

COPY src ./src

RUN mvn package -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/myapp.jar ./myapp.jar

EXPOSE 8080

CMD ["java", "-jar", "myapp.jar"]


FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]


