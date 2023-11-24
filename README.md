# deploy project using AWS & Terraform & GitHub Actions

## 0. 목차

- [개요](#1-개요)
- [Amazon Web Service](#2-Amazon-Web-Service)
- [Terraform](#3-Terraform)
- [Github Actions](#4-Github-Actions)
- [후기](#5-후기)

## 1. 개요

### 1.1 프로젝트 개요

- 프로젝트 이름: DevOps
- 프로젝트 목적:
  - FullStack web application project인 SSGBay를 배포
- 프로젝트 기간: 2023.11.22 ~ 진행중(Terraform)

### 1.2 서비스

**(1) Deployment**

- Amazon Web Service

**(2) Iac (Infrastructure as Code)**

- Terraform

**(3) CI/CD (Continuous Integration/Continuos Delivery)**

- GitHub Actions

### 1.3 프로젝트 진행 과정

| 일별                    | 내용                                                 |
| ----------------------- | ---------------------------------------------------- |
| 1일차 (11.22)           | - 주제 선정, 기술 스택 결정, 프로토 타입 구성        |
| 2일차 (10.27)           | - 데이터베이스 완성, 메인 페이지 간단 구현           |
| 3~6일차 (10.28 ~ 10.31) | - React+Flask CRUD 웹 페이지 완성                    |
| 7일차 (11.01)           | - React+Flask 부가 기능 추가                         |
| 8일차 (11.02)           | - 도커 이미지 생성 및 서비스 개선 후 쿠버네티스 배포 |

### 1.4 전체 디렉터리 구조

```
📁 project
 ├──── 📁 server
 │      ├──── 📁 .github
 │      │      └──── 📁 workflows
 │      │             └──── 📄 deploy.yml
 │      ├──── 📁 scripts
 │      │      ├──── 📄 afterInstall.sh
 │      │      ├──── 📄 beforeInstall.sh
 │      │      └──── 📄 runServer.sh
 │      └─────────── 📄 appspec.yml
...
...
 │
 └──── 📁 client
        └──── 📁 .github
               └──── 📁 workflows
                      └──── 📄 deploy.yml

```

- workflows

  - deploy.yml
    - Github Actions를 이용해 자동화한 작업 과정
    - 폴더 아래에 위치한 YAML 파일로 작업 과정을 설정
    - 하나의 코드 저장소(GitHub Repository)에 여러 개의 워크플로우 설정이 가능
    - 해당 워크플로우는 `on` 속성을 이용해 언제 실행되는지와 `job` 속성을 이용해 구체적으로 어떤 일을 하는지 명시

- appspec.yml

  - AWS CodeDeploy를 이용해 자동화한 작업 과정
  - React 앱은 Amazon EC2가 아닌 Amazon S3 버킷에 정적 상태로 저장하기 때문에 사용하지 않음

- scripts

  - appspec.yml에 사용할 셸 스크립트

## 2. Amazon Web Service

### 2.1 Frontend (Amazon S3 Bucket)

**(1) 초기 설정**

- rlatkdReact 계정 생성 후 로그인
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/addReactUser.jpg">

**(2) S3 버킷 설정**

- S3 버킷 생성
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/makeS3Bucket1.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/makeS3Bucket2.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/makeS3Bucket3.jpg">

- 정적 웹 사이트 호스팅 활성화
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/staticWebHostingActivate1.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/staticWebHostingActivate2.jpg">

- 버킷과 객체에 퍼블릭 액세스 권한 부여
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/addS3PublicAccessAutority1.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/addS3PublicAccessAutority2.jpg">

**(3) S3 버킷에 배포**

- React 앱 빌드

```
.\client>npm install
.\client>npm run build

.\CLIENT\BUILD
│   asset-manifest.json
│   favicon.ico
│   index.html
│   logo192.png
│   logo512.png
│   manifest.json
│   robots.txt
│
└───static
    ├───css
    │       main.3b876a84.css
    │       main.3b876a84.css.map
    │
    └───js
            787.cda612ba.chunk.js
            787.cda612ba.chunk.js.map
            main.37105d08.js
            main.37105d08.js.LICENSE.txt
            main.37105d08.js.map
```

- 빌드한 React 앱 소스 코드를 버킷에 등록
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/addReactCodeToBucket1.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/addReactCodeToBucket2.jpg">

**(4) 서비스 정상 작동 확인**

- 브라우저로 S3 버킷의 웹 사이트 앤드포인트로 접근
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/client/bucketEndpoint.jpg">

# CloudFront 해야함

###

### 2.2 Backend (Amazon EC2)

**(1) 초기 설정**

- rlatkdFlask 계정 생성 후 로그인
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/addFlaskUser.jpg">

- VPC 생성
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/createVPC.jpg">

- 보안 그룹 생성
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/createSg.jpg">

**(2) EC2 인스턴스 설정**

- Public Subnet에 EC2 인스턴스를 생성

<img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/createEC2Instance1.jpg">
<img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/createEC2Instance2.jpg">
<img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/createEC2Instance3.jpg">

- EC2 인스턴스의 Public IP 주소로 SSH 접속
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/accessSSH.jpg">

- Apache HTTP Server 설치

```
ubuntu@ip-10-0-3-255:~$ sudo apt update
ubuntu@ip-10-0-3-255:~$ sudo apt -y upgrade
ubuntu@ip-10-0-3-255:~$ sudo apt install -y apache2
ubuntu@ip-10-0-3-255:~$ sudo systemctl status apache2
ubuntu@ip-10-0-3-255:~$ sudo systemctl status apache2

● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-11-22 09:37:20 UTC; 8s ago
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 14846 (apache2)
      Tasks: 55 (limit: 1121)
     Memory: 5.0M
        CPU: 33ms
     CGroup: /system.slice/apache2.service
             ├─14846 /usr/sbin/apache2 -k start
             ├─14848 /usr/sbin/apache2 -k start
             └─14849 /usr/sbin/apache2 -k start

Nov 22 09:37:20 ip-10-0-3-255 systemd[1]: Starting The Apache HTTP Server...
Nov 22 09:37:20 ip-10-0-3-255 systemd[1]: Started The Apache HTTP Server.
```

<img src="https://github.com/rlatkd/DevOps/blob/main/assets/server/installApache.jpg">
```

- PHP 설치

```
ubuntu@ip-10-0-3-255:~$ sudo apt install -y php
ubuntu@ip-10-0-3-255:~$ sudo systemctl restart apache2
ubuntu@ip-10-0-3-255:~$ sudo systemctl status apache2

● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-11-22 09:40:07 UTC; 3s ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 21605 ExecStart=/usr/sbin/apachectl start (code=exited, status=0/SUCCESS)
   Main PID: 21609 (apache2)
      Tasks: 6 (limit: 1121)
     Memory: 10.0M
        CPU: 47ms
     CGroup: /system.slice/apache2.service
             ├─21609 /usr/sbin/apache2 -k start
             ├─21610 /usr/sbin/apache2 -k start
             ├─21611 /usr/sbin/apache2 -k start
             ├─21612 /usr/sbin/apache2 -k start
             ├─21613 /usr/sbin/apache2 -k start
             └─21614 /usr/sbin/apache2 -k start

Nov 22 09:40:07 ip-10-0-3-255 systemd[1]: Starting The Apache HTTP Server...
Nov 22 09:40:07 ip-10-0-3-255 systemd[1]: Started The Apache HTTP Server.
```

- 웹 루트 디렉터리 삭제

```
ubuntu@ip-10-0-3-255:~$ cd /var/www/html/
ubuntu@ip-10-0-3-255:/var/www/html$ ls
index.html

ubuntu@ip-10-0-3-255:/var/www/html$ sudo rm -rf *
ubuntu@ip-10-0-3-255:/var/www/html$ ls
```

### 2.3 Database (Amazon RDS)

**(1) 초기 설정**

- rlatkdMySQL 계정 생성 후 로그인
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/addMySQLUser.jpg">

\*\*(2) RDS 설정

- Private Subnet에 RDS를 생성
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/createRDS1.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/createRDS2.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/createRDS3.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/createRDS4.jpg">
  <img src="https://github.com/rlatkd/DevOps/blob/main/assets/database/createRDS5.jpg">

```python
...
...
from flask_jwt_extended import JWTManager
from flask_jwt_extended import create_access_token

app.config["JWT_SECRET_KEY"] = "super-secret"
jwt = JWTManager(app)

@app.route('/login', methods = ["GET", "POST"])
def login():
    if request.method == 'POST':
        userId = request.json.get('id')
        password = request.json.get('password')

        isid = database.idCheck(userId, password)
        if(isid) :
            access_token = create_access_token(identity=userId)

            return jsonify({'token': access_token, 'userId':userId}), 200

        else :

            return jsonify({'message': '잘못된 로그인 정보입니다. 다시 입력해주세요.'}), 401

@app.route('/login/signup', methods=['POST'])
def signup():
    try:
        userId = request.json.get('userId')
        userPwd = request.json.get('userPwd1')
        userNickname = request.json.get('userNickname')
        userPhone = request.json.get('userPhone')
        userInfo, status_code, headers = database.addUserInfo(userId, userPwd, userNickname, userPhone)
        access_token = create_access_token(identity=userId)
        return jsonify({"message": "계정 추가 및 로그인 성공", "token": access_token, 'userId':userId}), 200, {'Content-Type': 'application/json'}

    except Exception as e:
        print(e)
        return jsonify({"message": "요청중 에러가 발생"}), 500, {'Content-Type': 'application/json'}
...
...
```

**(2) 경매상품등록**

- 정적 파일이 위치할 디렉터리를 설정후 이미지 파일이 URL 형식으로 해당 경로에 저장되게 구현

```python
...
...
from os import path
app = Flask(__name__, static_folder='./resources/')
UPLOAD_FOLDER = path.join('.', 'resources/')

@app.route('/create', methods=['POST'])
def create():
    try:
        file = request.files['itemImage']
        filename = file.filename
        itemName = request.form.get('itemName')
        itemContent = request.form.get('itemContent')
        itemPrice = request.form.get('itemPrice')
        itemImage = filename
        userId = request.form.get('userId')
        endTime = request.form.get('endTime')
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
        image_url = 'http://10.0.0.4:5000/resources/' + file.filename
        print(image_url)
        return database.addItemInfo( itemName, itemContent, itemPrice, image_url, endTime, userId)

    except Exception as e:
        print(e)
        return jsonify({"message": "요청중 에러가 발생"}), 500, {'Content-Type': 'application/json'}
...
...
```

**(3) 경매낙찰시스템**

- 낙찰 시간에 도달되면 이용자에게 바로 알려주기 위하여 크론탭을 이용해 구현
- 크론탭은 지정한 시간마다 갱신됨

```python
...
...
def moveExpiredItemsToHistory():
    try:
        with pymysql.connect(**connectionString) as con:
            cursor = con.cursor()
            current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            print(current_time + ">>>")

            sql = "SELECT * FROM prehistory WHERE endTime < %s"
            cursor.execute(sql, (current_time,))
            expired_items = cursor.fetchall()

            if expired_items:
                for item in expired_items:
                    check_sql = "SELECT * FROM history WHERE item_id = %s"
                    cursor.execute(check_sql, (item['item_id'],))
                    existing = cursor.fetchone()

                    if existing:
                        update_sql = "UPDATE history SET user_id = %s WHERE item_id = %s"
                        cursor.execute(update_sql, (item['user_id'], item['item_id']))
                        con.commit()
                    else:
                        insert_sql = "INSERT INTO history (item_id, user_id) VALUES (%s, %s)"
                        cursor.execute(insert_sql, (item['item_id'], item['user_id']))
                        con.commit()
            print("Expired items moved to history table successfully.")

    except Exception as e:
        print("Error occurred:", e)

moveExpiredItemsToHistory()
```

- 시간을 1분마다로 지정 → 1분마다 갱신되어 1분주기로 확인하여 낙찰 시간에 도달하면 이용자에게 알림

```bash
* * * * * root /usr/local/bin/python /app/historyUpdate.py >> /var/log/cron.log
```

**(4) SQL Injection 방지**

- 데이터 처리 SQL 문자열을 `%s` 로 처리하여 SQL Injection 방지

```python
...
...
def getMyItem(user_id):
    try:
        with connect(**connectionString) as con:
            cursor = con.cursor()
            sql = "SELECT * FROM item where user_id = %s;"
            cursor.execute(sql, [user_id])
            result = cursor.fetchall()
            return result

    except Exception as e:
        print(e)
...
...
```

## 3. Database

### 3.1 디렉터리 구조

```
 📁 database
 ├──── 📄 init.sql
 └──── 📄 Dockerfile-mysql
```

- init.sql
  - Docker 이미지 빌드에 쓰일 MySQL 초기 설정용 query
  - MySQL Workbench 8.0 CE의 forwarding tool로 추출한 DB DDL로 작성
- Dockerfile-mysql
  - 명령어를 토대로 나열된 명령문을 수행하여 MySQL Docker Image를 생성

### 3.2 MySQL

**(1) MySQL 장점**

- 필요한 데이터와 불필요한 데이터의 지표를 정의하고 분리하는 것이 가능
- 사업부와 개발부 사이의 커뮤니케이션을 담당하는 데이터 기획자는 MySQL의 구조를 알면 개발자와의 의사소통이 원활해짐
- 정의하려는 지표를 바탕으로 데이터를 검토하고 백엔드 엔지니어와 소통하며 더욱 정확한 지표를 구현 가능

**(2) 정확한 지표구현이 필요한 이유**

- 서비스(ex. 거래사이트)에서 ‘거래액’이란 전사적인 지표를 정의할 때 할인이 포함된 금액으로 정의할지, 할인이 포함되지 않은 금액으로 정의할 것인지는 상황에 따라 달라질 수 있음
- 이 때 기획자가 DB에 대해 어느정도 알고 있다면 MySQL의 어떤 컬럼을 사용해서 해당 지표를 구현할 수 있을지 확인할 수 있음

## 4. Frontend

### 4.1 디렉터리 구조

```
📁 client
 ├──── 📁 node_modules
 ├──── 📁 src
 │      ├──── 📁 styles
 │      │      ├──── 📄 Card.js
 │      │      ├──── 📄 Footer.js
 │      │      ├──── 📄 Header.js
 │      │      ├──── 📄 Card.module.css
 │      │      ├──── 📄 CreatePage.module.css
 │      │      ├──── 📄 DetailPage.module.css
 │      │      ├──── 📄 Footer.module.css
 │      │      ├──── 📄 Header.module.css
 │      │      ├──── 📄 LoginPage.module.css
 │      │      ├──── 📄 MainPage.module.css
 │      │      └──── 📄 MyPage.module.css
 │      ├──── 📁 pages
 │      │      ├──── 📄 CreatePage.js
 │      │      ├──── 📄 DetailPage.js
 │      │      ├──── 📄 LoginPage.js
 │      │      ├──── 📄 MainPage.js
 │      │      ├──── 📄 MyPage.js
 │      │      └──── 📄 SignupPage.js
 │      ├──── 📄 App.js
 │      └──── 📄 App.css
 │──── 📄 package-lock.json
 │──── 📄 package.json
 └──── 📄 Dockerfile-react
```

- node_modules
  - 실제 라이브러리가 설치되는 디렉터리
- src
  - styles
    - 각 페이지 스타일 모아놓은 디렉터리
  - pages
    - 각 페이지 기능 구현한 코드 디렉터리
  - App.js
    - 모든 페이지를 핸들링 하는 root 파일
  - App.css
    - 모든 페이지 공통 적용 스타일 파일
- package(-lock).json
  - 패키지 목록과 프로젝트 기본 정보 및 빌드방식 담는 파일
- Dockerfile-react
  - 명령어를 토대로 나열된 명령문을 수행하여 React Docker Image를 생성

### 4.2 애플리케이션 특징

**(1) 디자인**

- 카드 UI를 이용해 전체 상품을 편하게 확인 가능

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/mainPage.png'/>

**(2) 필터링**

- 필터를 통해 최신순, 높은 가격순, 낮은 가격순으로 볼 수 있음

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/mainPageFilter.png'/>

**(3) 검색**

- 검색을 통해 해당 문자가 포함된 상품만 볼 수 있음

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/mainPageSearch.png'/>

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/mainPageSearch2.png'/>

**(4) 탭**

- 탭을 이용하여 보다 편리한 UI를 제공

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/Tab.png'/>

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/Tab2.png'/>

**(5) 유효성 검사**

- 비로그인시 로그인상태에서만 확인할 수 있는 내용(ex. 마이페이지) 등에 접근 불가능

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/validity1.png'/>

- 입력하지 않은 내용이 있으면 경고창이 나옴

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/validity2.png'/>

- 비밀번호가 일치하지않으면 경고창이 나옴

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/validity3.png'/>

- 본인 상품은 입찰 불가능

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/validity4.png'/>

**(6) 실시간 업데이트**

- 현재 낙찰 예정 금액보다 낮은 금액은 입력 불가

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/update1.png'/>

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/update2.png'/>

- 입찰을 하면 실시간으로 가격이 반영되어 변동됨

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/update3.png'/>

**(7) acync & await**

- async 함수 내부에서 await로 서버와 통신하고 promise가 끝나면 처리 결과에 따라 다른 결과 반환
- 비동기 함수를 사용하여 다른 작업을 병렬로 실행할 수 있어 시스템 성능 향상 가능
- 개발자가 읽기 좋은 코드를 작성할 수 있게 도와줌

```jsx
...
...
const handlerLogin = async () => {
  try {
    if (id.trim() === "") {
      alert("아이디를 입력하세요.");
      return;
    } else if (password.trim() === "") {
      alert("비밀번호를 입력하세요.");
      return;
    }

    const response = await fetch(`http://10.0.0.4:5000/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ id, password }),
    });

    console.log(response);

    if (response.ok) {
      const data = await response.json();
      const { token, userId } = data;
      console.log(token, userId);
      localStorage.setItem("token", token);
      localStorage.setItem("userId", userId);
      navigate("/");
      console.log("로그인 성공! 토큰:", token);
    } else {
      const data = await response.json();
      console.log("로그인 실패!");
      alert(data.message);
    }
  } catch (error) {
    console.error("로그인 중 오류 발생:", error);
  }
};
...
...
```

## 5. Docker

### 5.1 Dockerfile

```
📄 Dockerfile-flask
📄 Dockerfile-mysql
📄 Dockerfile-react
```

**(1) Dockerfile-flask**

- 프로젝트에 사용한 모듈, 패키지 호환성이 좋은 Python 3.11.5 버전을 사용
- 크론탭 내용 추가

```docker
FROM    python:3.11
RUN     apt-get update && apt-get install -y cron
WORKDIR /app
COPY    . .
RUN     pip install jwt
RUN     pip install --no-cache-dir -r requirements.txt
RUN     crontab -l | { cat; echo "* * * * * /usr/local/bin/python /app/historyUpdate.py >> /var/log/cron.log 2>&1"; } | crontab -
CMD     ["sh", "-c", "cron && python app.py"]
```

**(2) Dockerfile-mysql**

- 프로젝트 MySQL에 맞는 8.0 버전을 사용
- 환경변수는 root password만 할당
- Docker container 내부의 데이터베이스 지정 엔트리포인트인 `docker-entrypoint-initdb.d` 에 복사

```docker
FROM    mysql:8.0
ENV     MYSQL_ROOT_PASSWORD=1234
COPY    ./init.sql /docker-entrypoint-initdb.d
```

**(3) Dockerfile-react**

- 다단계 도커 빌드를 이용
  - 다단계 도커 빌드: 전체 빌드 시스템을 단일 파일에 포함 가능

```docker
FROM    node AS builder
RUN     mkdir /my-app
WORKDIR /my-app
COPY    . .
RUN     npm install
RUN     npm run build

FROM    nginx AS runtime
COPY    --from=builder /my-app/build/ /usr/share/nginx/html/
CMD     ["nginx", "-g", "daemon off;"]
```

### 5.2 Docker Image

**(1) Docker Image 빌드**

```bash
docker image build -t gnstkd/mymysql:1.0 -f Dockerfile-mysql .
docker image build -t gnstkd/myflask1.0 -f Dockerfile-flask .
docker image build -t gnstkd/myreact:1.0 -f Dockerfile-react .
```

**(2) 빌드된 Docker Image 확인**

```bash
docker image ls
```

```bash
REPOSITORY                                TAG                                        IMAGE ID       CREATED         SIZE
gnstkd/myreact                            1.0                                        c673b4d2fbd5   5 minutes ago   1.34GB
gnstkd/myflask                            1.0                                        c0ab8f938e1d   17 hours ago    190MB
gnstkd/mymysql                            1.0                                        a8d83556830d   17 hours ago    582MB
```

### 5.3 Docker Container

**(1) 로컬에서 Docker Container를 실행**

```bash
docker container run -d --name mymysql mymysql:1.0
docker container run -d -p 5000:5 --name myflask myflask:1.0
docker container run -d -p 3000:80 --name myreact myreact:1.0
```

**(2) 실행 된 Docker Container 확인**

```bash
docker container ls
```

```bash
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                    NAMES
7a8b90123c72   gnstkd/myreact:1.0     "/docker-entrypoint.…"   5 seconds ago    Up 4 seconds    0.0.0.0:3000->80/tcp     myreact
b1604da061ea   gnstkd/myflask:1.0     "sh -c 'cron && pyth…"   26 seconds ago   Up 25 seconds   0.0.0.0:5000->5000/tcp   myflask
e6eb9c3f7c44   gnstkd/mymysql:1.0     "docker-entrypoint.s…"   47 seconds ago   Up 45 seconds   3306/tcp, 33060/tcp      mymysql
```

**(3) 각 Docker Container들이 잘 작동하는지 확인**

```bash
docker container exec -it e6eb9c3f7c44 /bin/bash

bash-4.4# mysql -u root -p
Enter password:1234

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| auction            |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

mysql> show tables;
+-------------------+
| Tables_in_auction |
+-------------------+
| history           |
| item              |
| prehistory        |
| user              |
+-------------------+
```

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/mainPage.png'/>

### 5.4 Docker Hub

**(1) 로컬에 있는 Docker Image를 내 Docker Hub에 등록**

```bash
docker login
docker image push gnstkd/mymysql:1.0
docker image push gnstkd/myflask:1.0
docker image push gnstkd/myreact:1.0
```

**(2) 내 Docker Hub에 Image 등록된 것을 확인**

- [https://hub.docker.com/](https://hub.docker.com/)

```
💿 gnstkd/myreact:1.0
💿 gnstkd/myflask1.0
💿 gnstkd/mymysql:1.0
```

## 6. Kubernetes

### 6.1 kubernetes 디렉터리 구조

```
📁 k8s
 ├──── 📁 nfs
 │      ├──── 📄 nfs-deployment-service.yaml
 │      ├──── 📄 nfs-persistentvolume.yaml
 │      └──── 📄 nfs-persistentvolumeclaim-pod.yaml
 └──── 📁 service
        ├──── 📄 flask-deployment.yaml
        ├──── 📄 mysql-deployment.yaml
        └──── 📄 react-deployment.yaml
```

### 6.2 Kubernetes 클러스터 셋업

**(1) 가상머신 생성**

```bash
c:\kubernetes\vagrant-kubeadm-kubernetes>vagrant up
c:\kubernetes\vagrant-kubeadm-kubernetes>vagrant status
```

```bash
master                    running (virtualbox)
node01                    running (virtualbox)
node02                    running (virtualbox)
```

**(2) master node로 접속**

```bash
c:\kubernetes\vagrant-kubeadm-kubernetes>vagrant ssh master
```

```bash
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-83-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Nov  4 05:01:54 AM UTC 2023

  System load:  1.64306640625      Users logged in:        0
  Usage of /:   23.9% of 30.34GB   IPv4 address for eth0:  10.0.2.15
  Memory usage: 22%                IPv4 address for eth1:  10.0.0.10
  Swap usage:   0%                 IPv4 address for tunl0: 172.16.77.128
  Processes:    180

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Nov  4 05:01:55 2023 from 10.0.2.2
vagrant@master-node:~$
```

### 6.3 볼륨 (Volume)

**(1) hostPath**

- 파드가 실행된 호스트의 파일이나 디렉터리를 파드에 마운트
- 호스트에 있는 실제 파일이나 디렉터리를 마운트
- 파드를 재시작했을 때도 호스트에 데이터가 남아있음
- 파드가 재시작되어 새로운 노드에서 시작할 경우, 새로운 노드의 hostPath를 사용함 (이전 노드에서 사용한 hostPath 접근 불가)

**(2) NFS**

- NFS 서버를 이용해서 파드에 마운트
- 파드 하나에 안정성이 높은 외부 스토리지를 볼륨으로 설정한 후 해당 파드에 NFS 서버 설정
- 다른 파드는 NFS 볼륨으로 마운트

### 6.4 NFS

(1) MetalLB

- [https://metallb.universe.tf/](https://metallb.universe.tf/)
- On-Premise 환경에서 LoadBalancer 타입의 서비스를 연동하기 위해서 필요
- metallb-system의 네임스페이스 확인

```bash
kubectl get namespace
```

```bash
NAME              STATUS   AGE
default           Active   29d
ingress-nginx     Active   23d
kube-node-lease   Active   29d
kube-public       Active   29d
kube-system       Active   29d
metallb-system    Active   24d
```

(2) NFS를 사용한 퍼시스턴트 볼륨(Persistent Volume) 생성

- 사용자(또는 클라이언트 디바이스)가 네트워크 서버에 접속하여 서버 내 파일에 액세스 가능
- 여러 사용자가 데이터 충돌없이 동일한 파일을 공유할 수 있도록 하는 규칙 설정 가능
- nfs server는 `nfs-deployment-service.yaml`로 실행한 nfs-service의 ClusterIP

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-persistentvolume
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  nfs:
    path: /
    server: 172.17.60.101
```

### 6.5 서비스

**(1) flask-deployment.yaml**

- gnstkd/myflask:1.0 이미지 사용
- 5000번 포트 사용
- LoadBalancer 타입 서비스 및 IP 설정

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-flask-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-flask
  template:
    metadata:
      name: my-flask-pod
      labels:
        app: my-flask
    spec:
      containers:
        - name: my-flask-container
          image: gnstkd/myflask:1.0
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: my-flask-service
spec:
  type: LoadBalancer
  loadBalancerIP: 10.0.0.4
  ports:
    - name: my-flask
      port: 5000
      targetPort: 5000
  selector:
    app: my-flask
```

**(2) mysql-deployment.yaml**

- gnstkd/mymysql:1.0 이미지 사용
- 3306번 포트 사용
- ClusterIP 타입 서비스 설정
- ClusterIP를 사용한 이유:
  - MySQL 서비스는 클러스터 외부에 노출할 필요가 없기 때문
  - 외부에 노출하면 오히려 보안상의 문제가 됨
  - 외부에 노출하려면 LoadBalancer 혹은 NodePort(On-premise 환경) 사용
- subPath
  - volumeMount는 기본적으로 그 폴더를 덮어씌우기 때문에 기존 파일이 있을 시 파일이 사라지게됨
  - 빈 폴더에 mount 설정 시 문제가 없지만 그렇지 않으면 파일이 날아가는 일이 발생
  - subPath를 지정하게 되면 기존 파일은 유지하면서 subPath 하위에 새로운 파일이 저장됨
  - 단, mountPath와 subPath는 이름은 동일하게 작성

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-mysql-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-mysql
  template:
    metadata:
      name: my-mysql-pod
      labels:
        app: my-mysql
    spec:
      containers:
        - name: my-mysql-container
          image: gnstkd/mymysql:1.0
          ports:
            - containerPort: 3306
          volumeMounts:
            - name: mysql-volume
              mountPath: /var/lib/mysql
              subPath: mysql # 중요함
      volumes:
        - name: mysql-volume
          persistentVolumeClaim:
            claimName: nfs-persistentvolumeclaim
---
apiVersion: v1
kind: Service
metadata:
  name: my-mysql-service
spec:
  type: ClusterIP
  ports:
    - name: my-mysql
      port: 3306
      targetPort: 3306
  selector:
    app: my-mysql
```

**(3) react-deployment.yaml**

- gnstkd/myreact:1.0 이미지 사용
- 80번 포트 사용
- LoadBalancer 타입 서비스 및 IP 설정

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-react-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-react
  template:
    metadata:
      name: my-react-pod
      labels:
        app: my-react
    spec:
      containers:
        - name: my-react-container
          image: gnstkd/myreact:1.0
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: my-react-service
spec:
  type: LoadBalancer
  loadBalancerIP: 10.0.0.5
  ports:
    - name: my-react
      port: 80
      targetPort: 80
  selector:
    app: my-react
```

### 6.5 서비스 배포

**(1) yaml 파일 실행**

```bash
kubectl apply -f nfs-deployment-service.yaml
kubectl apply -f nfs-persistentvolume.yaml
kubectl apply -f nfs-persistentvolumeclaim-pod.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f flask-deployment.yaml
kubectl apply -f react-deployment.yaml
```

**(2) 서비스 및 파드 생성 확인**

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/kubectlgetall.png'/>

**(3) 10.0.0.5 로 접근 후 정상 작동 확인**

<img src='https://github.com/rlatkd/SSGBay-k8s/blob/main/assets/readmeImage/normal.png'/>

## 7. 후기

### 7.1 문제점 및 해결방안

**(1) 사진 업로드**

- 문제점: 다른 기능은 잘 작동하나 사진 업로드가 안 됨

```python
...
...
@app.route('/create', methods=['POST'])
def create():
    try:
        file = request.files['itemImage']
        filename = file.filename
        itemName = request.form.get('itemName')
        itemContent = request.form.get('itemContent')
        itemPrice = request.form.get('itemPrice')
        itemImage = filename
        userId = request.form.get('userId')
        endTime = request.form.get('endTime')
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
        image_url = 'http://127.0.0.1:5000/resources/' + file.filename
        print(image_url)
        return database.addItemInfo( itemName, itemContent, itemPrice, image_url, endTime, userId)

    except Exception as e:
        print(e)
        return jsonify({"message": "요청중 에러가 발생"}), 500, {'Content-Type': 'application/json'}
...
...
```

- 해결방안: 정적 파일이 위치할 디렉터리를 설정후 이미지 파일이 URL 형식으로 해당 경로에 저장되게 구현

```python
...
...
from os import path
app = Flask(__name__, static_folder='./resources/')
UPLOAD_FOLDER = path.join('.', 'resources/')

@app.route('/create', methods=['POST'])
def create():
    try:
        file = request.files['itemImage']
        filename = file.filename
        itemName = request.form.get('itemName')
        itemContent = request.form.get('itemContent')
        itemPrice = request.form.get('itemPrice')
        itemImage = filename
        userId = request.form.get('userId')
        endTime = request.form.get('endTime')
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
        image_url = 'http://10.0.0.4:5000/resources/' + file.filename
        print(image_url)
        return database.addItemInfo( itemName, itemContent, itemPrice, image_url, endTime, userId)

    except Exception as e:
        print(e)
        return jsonify({"message": "요청중 에러가 발생"}), 500, {'Content-Type': 'application/json'}
...
...
```

**(2) JWT**

- 문제점: `pip freeze >> requirements.txt` 로 모듈 및 패키지 명시했으나 Docker Image를 빌드하면 JWT가 적용되지 않음

```
blinker==1.6.2
cffi==1.16.0
click==8.1.7
colorama==0.4.6
cryptography==41.0.5
distlib==0.3.7
filelock==3.12.4
Flask==2.3.3
Flask-Cors==4.0.0
Flask-JWT-Extended==4.5.3
itsdangerous==2.1.2
Jinja2==3.1.2
MarkupSafe==2.1.3
mysql-connector==2.2.9
mysql-connector-python==8.2.0
platformdirs==3.10.0
protobuf==4.21.12
pycparser==2.21
PyJWT==2.8.0
PyMySQL==1.1.0
virtualenv==20.24.5
Werkzeug==2.3.7

```

- 해결방안: Dockerfile에 `RUN pip install jwt` 를 따로 명시

```docker
FROM    python:3.11
RUN     apt-get update && apt-get install -y cron
WORKDIR /app
COPY    . .

# 이 부분 추가#
RUN     pip install jwt
###############

RUN     pip install --no-cache-dir -r requirements.txt
RUN     crontab -l | { cat; echo "* * * * * /usr/local/bin/python /app/historyUpdate.py >> /var/log/cron.log 2>&1"; } | crontab -
CMD     ["sh", "-c", "cron && python app.py"]
```

- JWT는 Python 버전때문에 따로 추가함
- 애초에 import JWT를 하면 됐음

### 7.2 개선해야할 점

**(1) Backend**

- API 명세서를 Swagger를 이용해 일목요연하게 표현
- 내부 통신 시 URL은 REST의 규격에 맞게 설정
- JWT을 브라우저 local storage에 저장하여 보안 상 취약
  - Access Token의 탈취 위험을 감안해 유효기간을 짧게 설정하고, Refresh Token을 이용해 개선 가능
- test case 코드를 구현해 단위 테스트 코드 자동화 필요
- 짧은 시간에 빠르게 주먹구구식으로 개발을 하여 클린코딩이 전혀 되지 않음
- API 서버는 sidecar 등을 이용해 log를 수집하는 기능과 log 수집용 볼륨 등을 만들어야 함

**(2) Database**

- ER Diagram을 구성할 때, 외래키를 다르게 하면 조금 더 간편한 혹은 부가적인 구성 가능
- 기본 CRUD만을 구현하느라 참조목록이 너무 부족함
- 데이터베이스를 CronJob을 이용해 백업 용을 만들지 않음
- ORM을 사용했으면 구현이 더 편리할 수 있었음

**(3) Frontend**

- 회원가입 페이지 문자열 형식 (ex. 이메일) 지정
- 게시글 수정이나 삭제할 때 경고창을 한 번 더 나오게 해야함
- 웹 페이지 맨 아래에서 맨 위로 올리는 버튼이 필요
- 빌드한 이미지를 테스트할 때 `console.log` 등을 이용해 문제가 어디서 발생했는지 파악해야함

**(4) Docker & Kubernetes**

- ClusterIP는 서비스 이름으로 접근 가능하기 때문에 host IP 하드코딩 지양
- 가변적으로 바뀌어야하는 것들(IP주소)을 환경변수로 처리 필요
- configmap, secret 등을 이용해 설정을 분리하는 것이 필요
- 디플로이먼트 배포전략 및 업데이트전략 개선 필요

### 7.3 후기

- 혼자서 React, Flask, MySQL, Docker, Kubernetes까지 할 수 있어서 상당히 배운 점이 많고 매우 뿌듯했습니다.
- 또한 웹페이지 구현 부분에서의 다양한 개선점과 서비스 배포 부분에서의
  다른 기능을 이용하여 고객들에게 더 편리한 서비스를 제공하기 위해 노력이 필요함을 알게 되었습니다.

### 추가해야할 거(미완)

- PostgreSQL, SQLite 등 다양한 RDBMS가 있는데 MySQL을 왜 사용했는지에 대한 명확한 근거가 없음.
- NoSQL을 썼으면 안 됐나?
- server를 Python 기반으로 구현했으면 Flask 말고도 Django 있는데 Flask 사용 이유?
- 보안에 취약점 및 개선방법 더 생각할 거 없나?
- 공공 API 사용 및 가비아 도메인 사용할 생각 안 했나?
- monolithic 구조로 서비스를 구현했는데 규모가 커지면 MSA로 할 생각 해야됨
- 굳이 규모가 안 커도 기능 분배 용이 그러나 규모가 작은 서비스를 MSA로 분할할 때 단점도 분명 존재함
- 로컬에서 Docker, Kubernetes 말고 AWS나 Azure 등 퍼블릭 클라우드에 배포하려면 어떤 인프라를 구성해야 하나 미리 고민
- 배포 자동화하려면 GitHub Actions? Jenkins? 생각
- IaC를 위해서 Terraform 공부 필요
