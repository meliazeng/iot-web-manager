FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base

WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY . .
RUN dotnet restore "iot-web-manager.csproj"
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y build-essential nodejs
#RUN npm install -g npm
#RUN npm install
RUN dotnet build "iot-web-manager.csproj" -c Release -o /app 

FROM build AS publish
RUN dotnet publish "iot-web-manager.csproj" -c Release -o /app

FROM base as final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "iot-web-manager.dll]
