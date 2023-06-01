FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5275

ENV ASPNETCORE_URLS=http://+:5275

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DockerPocForDotNet.csproj", "./"]
RUN dotnet restore "DockerPocForDotNet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DockerPocForDotNet.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerPocForDotNet.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerPocForDotNet.dll"]
