FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
EXPOSE 80

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY ./Database/brokenaccesscontrol.db .
COPY ./logs/Access.log /app/logs/
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "brokenaccesscontrol.dll"]
