# API Artifacts Rules

Use these rules when generating Postman assets or request/response examples.

## Collection strategy

- use one project collection
- group requests by module
- keep the canonical files under `postman/`

## Required files

- `postman/base.postman_collection.json`
- `postman/local.postman_environment.json`

## Required local variables

- `baseUrl`
- `accessToken`
- `refreshToken`
- `userId`
- `companyId`
- `resourceId`

## Request naming

- prefer `<Module> / <Action>`
- keep names stable and readable
- do not encode HTTP method redundantly if the action name is already clear

## Auth capture rules

- login or refresh requests should capture `accessToken`
- capture `refreshToken`, `userId`, `companyId`, or `resourceId` when the response provides them
- do not invent token field names that are not in the spec

## Example rules

- each public endpoint should have at least one request example
- each public endpoint should have at least one success response example
- add error examples when the endpoint has important business failures
