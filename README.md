# Ruuvi Station gateway

This project offers an unofficial open-source implementation for
[Ruuvi Station gateway](https://ruuvi.com/manuals/station/app-settings/)
API server that can push Ruuvi Station mobile application
RuuviTag BLE measurements to an InfluxDB 1.8+ and 2.0+ time-series database.

This application has been tested to work with the following setup:

    RuuviTag BLE sensor         (official hardware)
      > Ruuvi Station           (official mobile application)
      > Ruuvi Station gateway   (this unofficial project)
      > InfluxDB 2.0            (official free-to-use SaaS cloud version)

### Getting started

You should have Node.js, Docker, and Docker Compose installed for the following steps.

InfluxDB Cloud is free-to-use for small amounts of data and does not require a credit card.
Creating an account should only take a few minutes.

1. Setup an InfluxDB server and organization at e.g. [InfluxDB Cloud](https://cloud.influxdata.com/).
2. [**Create Bucket** for InfluxDB](https://v2.docs.influxdata.com/v2.0/organizations/buckets/create-bucket/).
3. [Generate **Read/Write Token** for InfluxDB](https://v2.docs.influxdata.com/v2.0/security/tokens/create-token/).
4. Clone the repository with `git clone git@github.com:aleksihakli/ruuvi-station-gateway.git`.
5. Copy `.env.example` to `.env` and configure necessary environment flags.
6. Run the service with e.g. `docker-compose up --build`.
7. Set your Ruuvi Station mobile application to point to the service at `http://<ip>:<port>/api/station`.

You should now get measurements into the InfluxDB Cloud and can explore them
with the built-in data explorer as well as build dashboards for them.

### Environment variables

The server requires the following environment variables

| Name          | Description or example                    |
| ------------- | ----------------------------------------- |
| INFLUX_URL    | `https://<region>.cloud2.influxdata.com`  |
| INFLUX_TOKEN  | Influx API key                            |
| INFLUX_ORG    | Influx organization                       |
| INFLUX_BUCKET | Influx data bucket                        |

You can configure them in the `.env` file or inject them environment variables.

Docker Compose and the Node.js server both pick up the .env file.

### Serverless

The application should also work with e.g.

- AWS Lambdas,
- Azure Functions,
- Google Cloud Functions,

or similar serverless runtime environments.

The server itself is implemented in `index.js` and has under 100 lines of code
aside from dependencies defined in `package.json` and `package-lock.json`.

Deployment package into a cloud environment could be achieved with:

    zip ruuvi-station-gateway.zip index.js package.json

Configuration in serverless environments is ideally achieved without
hardcoding the configuration flags and all environments should support
setting cloud function configuration via environment variables.

### Testing

Health endpoint answers to plain GET requests:

    curl -v --header "Content-Type: application/json" http(s)://<host>:<port>/api/health

You can use cURL to test the backend deployment and data ingress with a POST verb and example measurement payload:

    curl -v --header "Content-Type: application/json" -d @measurement.json.example -X POST http(s)://<host>:<port>/api/station
