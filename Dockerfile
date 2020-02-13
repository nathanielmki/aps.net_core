FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["asp.net_core.csproj", "./"]
RUN dotnet restore "./asp.net_core.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "asp.net_core.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "asp.net_core.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "asp.net_core.dll"]
