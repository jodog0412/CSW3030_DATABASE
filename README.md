# CSW3030_DATABASE
It is my personal note for lecture `Introduction to database` in university.

## 1. Overview of database management
* Database system=Database management system(DBMS)+Hardware+Data+User
* Entities and Relations
  * unary relationship
  * binary relationship
  * ternary relationship
* File management system vs Database system
* Data Independence: the immunity of applications to change in storage structure and access technique

## 2. Database System Architecture
* 3-levels of data representation
  * Purpose
    * `Data Indenpendence`
    * 사용자의 view와 데이터 저장 방식에 대한 `flexibity` and `adaptability`   
  * Composition   
  <img src="https://user-images.githubusercontent.com/83653380/191163835-e74c5e01-1850-4e60-ab4e-e239526db440.png" width="60%" height="60%" alt="Database architecture diagram"></img>   
    * `External level`: view for application
    * `Conceptual level`: view for integrity
    * `Internal level`: view for physical storage    
* Client-Server Computing
  * Basic Structure
    * End User
    * Applications: Clients=frontend
    * DBMS: Server=backend
    * DataBase
  * Distributed Processing   
  ![Client-DB](https://user-images.githubusercontent.com/83653380/191639352-5b2e89a0-693e-4b91-9339-625c6d1fb756.png)
  ![Client-Server](https://user-images.githubusercontent.com/83653380/191639525-a234e00d-b15c-43ab-b083-71afdf109d41.png)



