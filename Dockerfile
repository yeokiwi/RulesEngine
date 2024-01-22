FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /RulesEngine

# Copy everything
COPY . ./
RUN ls -la
# Restore as distinct layers
RUN dotnet restore
RUN dotnet build
WORKDIR /RulesEngine/demo/DemoApp
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /RulesEngine/demo/demoApp
COPY --from=build-env /RulesEngine/demo/DemoApp/out .
ENTRYPOINT ["dotnet", "DemoApp.dll"]