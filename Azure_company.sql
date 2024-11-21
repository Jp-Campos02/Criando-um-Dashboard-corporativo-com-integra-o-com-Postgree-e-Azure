-- Criação do schema
CREATE SCHEMA IF NOT EXISTS azure_company;

-- Seleciona o schema
SET search_path TO azure_company;

-- Consulta as restrições existentes no schema
SELECT * FROM employee
WHERE constraint_schema = 'azure_company';

-- Tabela Empregado
CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary NUMERIC(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn)
);

-- Adiciona chave estrangeira para Super_ssn
ALTER TABLE employee
ADD CONSTRAINT fk_employee
FOREIGN KEY (Super_ssn) REFERENCES employee (Ssn)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Tabela Departament
CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    CONSTRAINT fk_dept FOREIGN KEY (Mgr_ssn) REFERENCES employee (Ssn)
);

-- Tabela Dept_locations
CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament (Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Tabela Project
CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES departament (Dnumber)
);

-- Tabela Works_on
CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours NUMERIC(3,1) NOT NULL,
    CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee (Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project (Pnumber)
);

-- Tabela Dependent
CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee (Ssn)
);

-- Visualizar tabelas no schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'azure_company';

-- Visualizar estrutura da tabela dependent
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'azure_company' AND table_name = 'dependent';

-- Inserções na tabela employee
INSERT INTO employee VALUES 
('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, '333445555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, '888665555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, '888665555', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

-- Inserções na tabela dependent
INSERT INTO dependent VALUES 
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- Inserções na tabela departament
INSERT INTO departament VALUES 
('Research', 5, '333445555', '1988-05-22', '1986-05-22'),
('Administration', 4, '987654321', '1995-01-01', '1994-01-01'),
('Headquarters', 1, '888665555', '1981-06-19', '1980-06-19');

-- Inserções na tabela dept_locations
INSERT INTO dept_locations VALUES 
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- Inserções na tabela project
INSERT INTO project VALUES 
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

-- Inserções na tabela works_on
INSERT INTO works_on VALUES 
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 0.0);

-- Consultas SQL

-- Seleciona todos os dados da tabela employee
SELECT * FROM employee;

-- Contagem de dependentes por empregado
SELECT Ssn, COUNT(Essn) 
FROM employee e
JOIN dependent d ON e.Ssn = d.Essn;

-- Seleciona todos os dados da tabela dependent
SELECT * FROM dependent;

-- Seleciona dados de um empregado específico
SELECT Bdate, Address 
FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

-- Seleciona dados de um departamento específico
SELECT * 
FROM departament 
WHERE Dname = 'Research';

-- Recupera empregados que trabalham no departamento de pesquisa
SELECT Fname, Lname, Address
FROM employee
JOIN departament ON Dnumber = Dno
WHERE Dname = 'Research';

-- Seleciona todos os projetos
SELECT * FROM project;

-- Informações de departamentos presentes em Stafford
SELECT Dname AS Department, Mgr_ssn AS Manager 
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
WHERE Dlocation = 'Stafford';

-- Recupera informações dos projetos em Stafford
SELECT * 
FROM project p
JOIN departament d ON Dnum = Dnumber
WHERE Plocation = 'Stafford';

-- Recupera informações de departamentos e projetos em Stafford
SELECT Pnumber, Dnum, Lname, Address, Bdate
FROM project p
JOIN departament d ON Dnum = Dnumber
JOIN employee e ON Mgr_ssn = Ssn
WHERE Plocation = 'Stafford';

-- Recupera empregados com Dno em valores específicos
SELECT * 
FROM employee 
WHERE Dno IN (3, 6, 9);

-- Calcula INSS para cada empregado
SELECT Fname, Lname, Salary, ROUND(Salary * 0.011, 2) AS INSS 
FROM employee;

-- Aumento salarial para gerentes em ProductX
SELECT e.Fname, e.Lname, 1.1 * e.Salary AS increased_sal 
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'ProductX';
