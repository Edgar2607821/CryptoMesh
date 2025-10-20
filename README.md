# CryptoMesh 

<p align="center">
<img src="images/logo.svg"/>
</p>
<div align=center>
<a href="https://test.pypi.org/project/mictlanx/"><img src="https://img.shields.io/badge/version-0.0.1--alpha.0-green" alt="build - 0.0.160-alpha.3"></a>
</div>
Crypto Mesh is a platform engineered to build secure service meshes specifically tailored for machine learning applications. By leveraging advanced cryptographic protocols alongside a robust, distributed mesh architecture, it ensures that data exchanged between machine learning services remains confidential and tamper-proof.



## ⚠️ Clone the repo and setup a remoto 🍴: 

1. You must clone the remote from the organization of Muyal: 
```bash
git clone git@github.com:muyal-research-group/CryptoMesh.git
```

2. You must create a fork (please check it up in the [Contribution](#contribution) section)

3. Add a new remote in your local git: 
   ```bash
   git remote add <remote_name> <ssh> 
   ```
You must select ```<remote_name>``` and you must copy the ```<ssh>``` uri in the github page of your 

<div align="center">
<img width=350 src="images/gitclone_ssh.png"/>
</div>

4. Remember to push all your commits to your ```<remote_name>``` to avoid github conflicts. 

Thats it!  let's get started 🚀

## Getting started

You must install the following software: 

- [Docker](https://github.com/pyenv/pyenv?tab=readme-ov-file#linuxunix)
- Poetry
    ```bash
    pip3 install poetry
    ```
- [pyenv](https://github.com/pyenv/pyenv?tab=readme-ov-file#linuxunix) (Optional)
    ```bash
    curl -fsSL https://pyenv.run | bash
    ```


Once you get all the software, please execute the following command to install the dependencies of the project: 

```bash
poetry install
```
### How to deploy database, broker and API

**Install docker and docker Compose:**

- Make sure Docker is installed on your system. See [Docker's installation guide](https://docs.docker.com/get-docker/) for instructions.
- Docker Compose is usually included with Docker Desktop. Otherwise, follow [Docker Compose installation instructions](https://docs.docker.com/compose/install/).

**Navigate to your project directory:**

- Open a terminal and change to the directory where your `docker-compose.yml` file is located.

**Start the services:**

- Run the following command to build the images (if necessary) and start all services in detached mode (runs in background):
```bash
docker-compose up --build -d
```

- Alternatively, to see the logs in the console (not detached):
```bash
docker-compose up --build
```

**Stopping the services:**
```bash
docker-compose stop
```

**Start the services:**
```bash
docker-compose start
```

**Stopping and Removing Containers**
```bash
docker-compose down
```

**Dockerfile**

- `FROM python:3.11-slim`: Lightweight base image with Python 3.11.
- `WORKDIR /app`: Sets the working directory inside the container.
- `COPY requirements.txt .` and `RUN pip install --no-cache-dir -r requirements.txt`: Copies and installs dependencies.
- `COPY . .`: Copies all the source code into the container.
- `CMD ["uvicorn", "cryptomesh.server:app", "--host", "0.0.0.0", "--port", "19000"]`: Sets the command to start the FastAPI server.

**docker-compose.yml**

- Defines services for the database (`mongo`), the broker (`rabbitmq`), and the API (`cryptomesh-api`).
- Uses environment variables to configure connections.
- Maps ports to access services from the host machine.
- Uses `depends_on` to ensure the correct startup order.

**Environment Variables**

Create a `.env` file (or `.env.staging` / `.env.prod`) with the following variables:

### API Settings
- `CRYPTOMESH_HOST`: Host where the API will run (default `0.0.0.0`)
- `CRYPTOMESH_PORT`: Port for the API (default `19000`)
- `CRYPTOMESH_MAX_CPU`: Max CPU cores the API can use (default `4`)
- `CRYPTOMESH_MAX_RAM`: Max RAM in GB (default `8`)
- `CRYPTOMESH_MAX_DEPLOYED_ENDPOINTS`: Maximum number of endpoints that can be deployed simultaneously (default `2`)
- `CRYPTOMESH_DEBUG`: Enable debug mode (`1` for true, `0` for false)
- `CRYPTOMESH_TITLE`: Title of the API (default `CryptoMesh API`)
- `CRYPTOMESH_API_PREFIX`: Prefix for API routes (default `/api/v1`)
- `CRYPTOMESH_VERSION`: API version (default `1.0.0`)

### MongoDB Settings
- `CRYPTOMESH_MONGO_PORT`: Port on the host mapping to MongoDB container (default `27018`)
- `CRYPTOMESH_MONGO_DATABASE_NAME`: Database name (default `cryptomesh`)
- `CRYPTOMESH_MONGODB_URI`: MongoDB connection URI (default `mongodb://crypto-mesh-db:27017/cryptomesh`)

### Logging
- `CRYPTOMESH_LOG_PATH`: Directory for logs (default `./logs`)
- `CRYPTOMESH_LOG_LEVEL`: Log level (`DEBUG`, `INFO`, etc.)
- `CRYPTOMESH_LOG_ROTATION_WHEN`: Rotation period unit (`h` for hour, `m` for minute)
- `CRYPTOMESH_LOG_ROTATION_INTERVAL`: Interval for log rotation (default `10`)
- `CRYPTOMESH_LOG_TO_FILE`: Write logs to file (`1` yes, `0` no)
- `CRYPTOMESH_LOG_ERROR_FILE`: Save errors to a separate file (`1` yes, `0` no)

### MictlanX Router
- `CRYPTOMESH_SUMMONER_IP_ADDR`: Hostname or IP of the MictlanX Summoner (default `mictlanx-summoner-0`)
- `CRYPTOMESH_MICTLANX_URI`: URI for MictlanX Router (e.g., `mictlanx://mictlanx-router-0@mictlanx-router-0:60666?/api_version=4&protocol=http`)
- `CRYPTOMESH_MICTLANX_LOG_PATH`: Path for MictlanX logs (default `/app/logs`)

### Axo Logging (Optional)
- `CRYPTOMESH_AXO_LOG_PATH`: Path for Axo logs (default `/app/logs`)




**Logs**
- API logs are saved in the `./logs` directory thanks to the mounted volume.

### Automating Docker Image Build and Publication

Now that you can run ShieldX locally using Docker Compose, you can also automate the image build and publication process using scripts and GitHub Actions.

#### 🧱 Local Build (build.sh)

To build the image locally and deploy the full stack (API + MongoDB + RabbitMQ), simply run:

```bash
./build.sh [IMAGE_NAME] [IMAGE_TAG]
```

**Example:**

```bash
./build.sh cryptomesh api-0.0.1a0
```

This command will:

* Build the Docker image `leodan/cryptomesh-api:0.0.1a0`
* Restart the stack using `docker-compose.yml`
* Display a custom ASCII banner during build

If no version is specified, `latest` will be used automatically.

---

#### 🚀 Automatic Publish via GitHub Actions

A dedicated GitHub Action automatically builds and pushes the Docker image to Docker Hub whenever a new tag is created.

**Workflow file:**

```
.github/workflows/docker-publish.yml
```

**Trigger condition:**

```yaml
on:
  push:
    tags:
      - "*"
```

**How it works:**

1. When a tag is pushed (e.g. `0.0.1a0`), the Action runs automatically.
2. It builds the image using the repository Dockerfile.
3. It logs in to Docker Hub using secrets.
4. It pushes the tagged image to the public registry.

**Example:**

```bash
git tag 0.0.1a0
git push origin 0.0.1a0
```

## Running Tests

All tests for this project are located in the `tests/` folder at the root of the repository. We use [pytest](https://docs.pytest.org/) as our testing framework.

### How to Run the Tests

1. **Navigate to the project directory:**
   ```bash
   cd path/to/your/project

2. Run all tests:
    ```bash
    pytest
    ```
3. Run a specific test file: 
    ```bash
    pytest tests/test_policy_manager.py
    ```

## Contributing[](#contribution)

Please follow these steps to help improve the project:

1. **Fork the Repository:**
   - Click the "Fork" button at the top right of the repository page to create a copy under your GitHub account.

2. **Create a Feature Branch:**
   - Create a new branch from the `main` branch. Use a descriptive branch name (e.g., `feature/new-algorithm` or `bugfix/fix-issue`):
     ```bash
     git checkout -b feature/your-feature-name
     ```

3. **Make Your Changes:**
   - Implement your feature or fix the issue. Make sure to write or update tests located in the `tests/` folder as needed.

4. **Run the Tests:**
   - Verify that all tests pass by running:
     ```bash
     pytest
     ```
   - Ensure that your changes do not break any existing functionality.

5. **Commit and Push:**
   - Write clear and concise commit messages. Then push your branch to your fork:
     ```bash
     git push origin feature/your-feature-name
     ```

6. **Open a Pull Request:**
   - Navigate to the repository on GitHub and open a pull request against the `main` branch. Please include a detailed description of your changes and the motivation behind them.

7. **Review Process:**
   - Your pull request will be reviewed by the maintainers. Feedback and further changes may be requested.


## 1. Models and Entities

### a. ResourcesModel
- **Description:** Represents the computational resources allocated to system components.
- **Attributes:**
  - `cpu` (int): Number of CPU cores allocated.
  - `ram` (str): Amount of RAM allocated (e.g., `"2GB"`).

### b. StorageModel
- **Description:** Defines the storage configuration for a function.
- **Attributes:**
  - `storage_id` (str): Unique identifier.
  - `capacity` (str): Allocated storage capacity (e.g., `"10GB"`).
  - `source_path` (str): Source path.
  - `sink_path` (str): Destination path.
  - `created_at` (datetime): Creation timestamp (default: `datetime.utcnow`).

### c. RoleModel
- **Description:** Defines a role used in security policies.
- **Attributes:**
  - `role_id` (str): Unique identifier of the role.
  - `name` (str): Descriptive name of the role.
  - `description` (str): Description of the role.
  - `permissions` (List[str]): List of associated permissions.
  - `created_at` (datetime): Creation timestamp.

### d. SecurityPolicyModel
- **Description:** Establishes a security policy by referencing one or more roles.
- **Attributes:**
  - `sp_id` (str): Unique identifier for the policy.
  - `roles` (List[str]): List of role IDs corresponding to `RoleModel` records.
  - `requires_authentication` (bool): Indicates if authentication is required.
  - `created_at` (datetime): Creation timestamp.

### e. EndpointModel
- **Description:** Represents a container or execution server that deploys functions.
- **Attributes:**
  - `endpoint_id` (str): Unique identifier.
  - `name` (str): Descriptive name of the endpoint.
  - `image` (str): Container image to be used.
  - `resources` (ResourcesModel): Allocated resources.
  - `security_policy` (str): Reference to a security policy (using the `sp_id` from SecurityPolicyModel).
  - `created_at` (datetime): Creation timestamp.

### f. EndpointStateModel
- **Description:** Records the operational state of an endpoint (e.g., "warm", "cold") along with additional metadata.
- **Attributes:**
  - `state_id` (str): Unique state identifier.
  - `endpoint_id` (str): Reference to the related EndpointModel.
  - `state` (str): Current state of the endpoint.
  - `metadata` (Dict[str, str]): Additional metadata.
  - `timestamp` (datetime): Timestamp of the state record (default: `datetime.utcnow`).

### g. ServiceModel
- **Description:** Represents a service that groups microservices and has an associated security policy.
- **Attributes:**
  - `service_id` (str): Unique identifier.
  - `security_policy` (str): Reference to the security policy (`sp_id` from SecurityPolicyModel).
  - `microservices` (List[str]): List of microservice IDs that belong to this service.
  - `resources` (ResourcesModel): Allocated resources.
  - `created_at` (datetime): Creation timestamp.

### h. MicroserviceModel
- **Description:** Represents a microservice that belongs to a ServiceModel and groups multiple functions.
- **Attributes:**
  - `microservice_id` (str): Unique identifier.
  - `service_id` (str): The ServiceModel ID to which it belongs.
  - `functions` (List[str]): List of function IDs.
  - `resources` (ResourcesModel): Allocated resources.
  - `created_at` (datetime): Creation timestamp.

### i. FunctionModel
- **Description:** Represents a function (or task) that gets deployed and executed on an endpoint.
- **Attributes:**
  - `function_id` (str): Unique identifier.
  - `microservice_id` (str): Reference to the parent MicroserviceModel.
  - `image` (str): Container image used for the function.
  - `resources` (ResourcesModel): Allocated resources.
  - `storage` (str): Reference (ID) to a StorageModel.
  - `endpoint_id` (str): Reference to the EndpointModel where it is deployed.
  - `deployment_status` (str): Deployment status (e.g., "initiated", "completed", "failed").
  - `created_at` (datetime): Creation timestamp.

### j. FunctionStateModel
- **Description:** Records the real-time execution state of a function.
- **Attributes:**
  - `state_id` (str): Unique state identifier.
  - `function_id` (str): FunctionModel reference.
  - `state` (str): Current execution state (e.g., "running", "completed", "failed").
  - `metadata` (Dict[str, str]): Additional execution-related data.
  - `timestamp` (datetime): Timestamp (default: `datetime.utcnow`).

### k. FunctionResultModel
- **Description:** Stores the final result (and/or metadata) of a function's execution.
- **Attributes:**
  - `state_id` (str): Identifier used to associate with a FunctionStateModel.
  - `function_id` (str): Reference to the FunctionModel.
  - `metadata` (Dict[str, str]): Execution result and additional data.
  - `timestamp` (datetime): Timestamp (default: `datetime.utcnow`).

---

## 2. Entity Relationships

- **Security Policy and Roles:**  
  The `SecurityPolicyModel` contains a list of role IDs (in the `roles` field). These IDs refer to entries in the `RoleModel`, allowing policies to group multiple roles.

- **Endpoints and Security Policy:**  
  Each `EndpointModel` holds a `security_policy` field that contains the `sp_id` of a security policy. This links endpoints with specific security rules and restrictions.

- **Services, Microservices, and Functions:**  
  - A `ServiceModel` groups its microservices via the `microservices` field (a list of microservice IDs).
  - A `MicroserviceModel` holds a list of functions (by their `function_id`), establishing a hierarchy where services contain microservices and microservices group functions.

- **Functions and Endpoints:**  
  Each `FunctionModel` includes an `endpoint_id` field that references the EndpointModel where it is deployed, creating a direct link between functions and their operational environment.

- **State and Results Tracking:**  
  - The `EndpointStateModel` logs the operational state of endpoints.
  - The `FunctionStateModel` tracks the execution state of functions in real time.
  - The `FunctionResultModel` stores the final outcomes of function executions and can be related back to the function’s state through the `state_id`.

---



