'''
Ambers conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy:

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.
Note:
The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.
Input Format

The following tables contain company data:
Company, Lead_Manager, Senior_Manager, Manager, Employee

Sample Input
Company Table:Lead_Manager Table:Senior_Manager Table:Manager Table:Employee Table:
Sample Output
C1 Monika 1 2 1 2
C2 Samantha 1 1 2 2
Explanation

In company C1, the only lead manager is LM1. There are two senior managers, SM1 and SM2, under LM1. There is one manager, M1, under senior manager SM1. There are two employees, E1 and E2, under manager M1.
In company C2, the only lead manager is LM2. There is one senior manager, SM3, under LM2. There are two managers, M2 and M3, under senior manager SM3. There is one employee, E3, under manager M2, and another employee, E4, under manager, M3.

'''

SOLUTION: 


SELECT 
    c.company_code, 
    c.founder,
    COUNT(DISTINCT l.lead_manager_code) as lead_manager_count,
    COUNT(DISTINCT s.senior_manager_code) as senior_manager_count,
    COUNT(DISTINCT m.manager_code) as manager_count,
    COUNT(DISTINCT e.employee_code) as employee_count
FROM Company c
LEFT JOIN Lead_Manager l 
    ON c.company_code = l.company_code
LEFT JOIN Senior_Manager s 
    ON l.lead_manager_code = s.lead_manager_code
LEFT JOIN Manager m 
    ON s.senior_manager_code = m.senior_manager_code
LEFT JOIN Employee e 
    ON m.manager_code = e.manager_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;