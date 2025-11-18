#FROM eclipse-temurin:17-jdk-alpine
    
#EXPOSE 8080
 
#ENV APP_HOME /usr/src/app

#COPY target/*.jar $APP_HOME/app.jar

#WORKDIR $APP_HOME

#CMD ["java", "-jar", "app.jar"]

# المرحلة الأولى: بناء التطبيق
FROM maven:3.9.3-eclipse-temurin-17 AS build

# تعريف مكان التطبيق
WORKDIR /app

# نسخ ملفات المشروع
COPY pom.xml .
COPY src ./src

# بناء الـ JAR بدون اختبارات (لتسريع البناء)
RUN mvn clean package -DskipTests

# المرحلة الثانية: الصورة النهائية خفيفة
FROM eclipse-temurin:17-jdk-alpine

# متغير لمكان التطبيق
ENV APP_HOME /usr/src/app

# إنشاء مجلد التطبيق
WORKDIR $APP_HOME

# نسخ الـ JAR النهائي من مرحلة البناء
COPY --from=build /app/target/*.jar app.jar

# فتح البورت
EXPOSE 8080

# الأمر اللي هيشتغل عند تشغيل الحاوية
CMD ["java", "-jar", "app.jar"]
