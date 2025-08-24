# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and projects
COPY api/api.csproj ./api/
RUN dotnet restore ./api/api.csproj


# Build
COPY api/ ./api/
WORKDIR /src/api
RUN dotnet build api.csproj -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish api.csproj -c Release -o /app/publish

# Stage 3: Run Stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "api.dll"]