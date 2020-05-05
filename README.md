# Prikka

This project offers an open-source implementation for
[Ruuvi Station](https://ruuvi.com/manuals/station/app-settings/)
gateway API server that can push Ruuvi Station mobile application
measurements from RuuviTag to an InfluxDB 1.8+ and 2.0+ time-series database.

This application has been tested to work with the following setup:

    RuuviTag                    (Ruuvi hardware sensor)
      > Ruuvi Station           (Ruuvi mobile application)
      > Prikka                  (this project)
      > InfluxDB 2.0            (free-to-use SaaS cloud)

**Please note** that this is a community project under MIT license.

### Getting started

You should have Node.js, Docker, and Docker Compose installed for the following steps.

InfluxDB Cloud is free-to-use for small amounts of data and does not require a credit card.
Creating an account should only take a few minutes.

1. Setup an InfluxDB server and organization at e.g. [InfluxDB Cloud](https://cloud.influxdata.com/).
2. [**Create Bucket** for InfluxDB](https://v2.docs.influxdata.com/v2.0/organizations/buckets/create-bucket/).
3. [Generate **Read/Write Token** for InfluxDB](https://v2.docs.influxdata.com/v2.0/security/tokens/create-token/).
4. Clone the repository with `git clone git@github.com:ruuvi/prikka.git`.
5. Copy `.env.example` to `.env` and configure necessary environment flags.
6. Run the service with e.g. `docker-compose up --build`.
7. Set your Ruuvi Station mobile application to point to the service at `http://<ip>:<port>/api/station`.

You should now get measurements into the InfluxDB Cloud and can explore them
with the built-in data explorer as well as build dashboards for them.

### Environment variables

The server requires the following environment variables

| Name            | Description or example                    |
| --------------- | ----------------------------------------- |
| `INFLUX_URL`    | `https://<region>.cloud2.influxdata.com`  |
| `INFLUX_TOKEN`  | Influx API key                            |
| `INFLUX_ORG`    | Influx organization                       |
| `INFLUX_BUCKET` | Influx data bucket                        |

You can configure them in the `.env` file or configure them via
e.g. cloud platform runtime configuration for other systems.

### API endpoints

The server exposes the following API endpoints

| URL                | Method | Description or example        |
| ------------------ | ------ | ----------------------------- |
| GET `/api/health`  | GET    | Uptime monitoring             |
| GET `/api/station` | POST   | Ruuvi Station Gateway URL     |

### Serverless

The application should also work with e.g.

- AWS Lambdas,
- Azure Functions,
- Google Cloud Functions,
- Heroku,

or similar more or less serverless runtime environments.

The server itself is implemented in `index.js` and has under 100 lines of code
aside from dependencies defined in `package.json` and `package-lock.json`.

Deployment package into a cloud environment could be achieved with:

    zip prikka.zip index.js package.json

Configuration in serverless environments is ideally achieved without
hardcoding the configuration flags and all environments should support
setting cloud function configuration via environment variables.

### Testing

Health endpoint answers to plain GET requests:

    curl -v -H "Content-Type: application/json" <host>:<port>/api/health

You can use cURL to test the backend deployment and data ingress with a POST verb and example measurement payload:

    curl -v -H "Content-Type: application/json" -d @measurement.json.example -X POST <host>:<port>/api/station
