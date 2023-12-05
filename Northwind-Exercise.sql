use Northwind

-- Toplam Ciro miktarı

SELECT FORMAT(SUM((UnitPrice * Quantity) - (UnitPrice * Quantity * Discount)), 'C2') AS Sonuç
FROM [Order Details]

--Hangi çalışan hangi çalışana bağlı (İsim-İsim)

select e.FirstName as 'Manager Name',e.LastName as 'Maneger Lastname',em.FirstName,em.LastName
from Employees e 
inner join Employees em
on e.EmployeeID=em.ReportsTo
ORDER BY e.FirstName ASC
-- Self Join kullanılıdı...

--
--Çalışanların toplam satışları

select FORMAT(SUM(Freight),'C2') as 'Çalışanların Toplam Satışları' 
from Orders 
where ShippedDate IS NOT NULL

--
--İhracat yapılan ülkeler

select Distinct Country 
from Customers

--
--Ürünlere göre satış oranı

select ProductName,UnitPrice,UnitsInStock,UnitsOnOrder,UnitsOnOrder * UnitPrice as 'Geliri'
from Products
where UnitsOnOrder > 0
Order By ProductName

--


-- Ürün kartegorilerine göre satişlarım nasıl ? (Gelir bazında)

select Categories.CategoryName,FORMAT(SUM(O.UnitPrice*O.Quantity),'C2') as 'Toplam gelir' from Categories
INNER  JOIN Products ON Categories.CategoryID=Products.CategoryID
INNER JOIN  [Order Details] O ON Products.ProductID=O.ProductID
GROUP BY Categories.CategoryName
ORDER BY 2 DESC

--
-- Ürün kategorilerine göre satışlarım nasıl? (Adet bazında)

select Categories.CategoryName,COUNT(Products.UnitsInStock) as 'Ürün adeti',FORMAT(SUM([Order Details].UnitPrice*[Order Details].Quantity),'C2') as 'Toplam gelir' from Categories
INNER JOIN Products ON Categories.CategoryID=Products.ProductID
INNER JOIN [Order Details] ON Products.ProductID=[Order Details].ProductID
GROUP BY Categories.CategoryName
ORDER BY [Toplam gelir] DESC

--
-- Çalışanlarım ürün bazında ne kadarlık satış yapmışlar? (Çalışan  –  Ürün – Adet – Gelir tam istenilen oldup olmadığını sor

select Employees.FirstName,Employees.LastName,Products.ProductName,[Order Details].Quantity,SUM(Products.UnitPrice*Products.UnitsInStock) as 'Toplam Gelir'
from Employees 
INNER JOIN [Order Details] ON Employees.EmployeeID=[Order Details].ProductID
INNER JOIN Products On Employees.EmployeeID=Products.ProductID
GROUP BY Employees.FirstName,Employees.LastName,Products.ProductName,[Order Details].Quantity
ORDER BY [Order Details].Quantity

--
-- Hangi kargo şirketine toplam ne kadar ödeme yapmışım?

select Shippers.CompanyName as 'Kargo Şirketi',FORMAT(SUM(Orders.Freight+0), 'C2') as 'Toplam Ödenen'
from Shippers 
RIGHT JOIN Orders ON Shippers.ShipperID=Orders.ShipVia
GROUP BY Shippers.CompanyName
ORDER BY [Toplam Ödenen] ASC

--
-- Hangi tedarkçiden aldığım ürünlerden ne kadar satmışım? (Satış bilgisi order details tablosundan alınacak) (Gelir ve adet bazında)

select Suppliers.CompanyName,Products.ProductName,Products.UnitsInStock,FORMAT(SUM([Order Details].UnitPrice * Quantity * Discount), 'C2') as 'Toplam Gelir'
from Suppliers 
INNER JOIN Products ON Suppliers.SupplierID=Products.SupplierID
INNER JOIN [Order Details] ON Products.ProductID=[Order Details].ProductID
Where Products.UnitsInStock > 0
GROUP BY Suppliers.CompanyName,Products.ProductName,Products.UnitsInStock
ORDER BY Suppliers.CompanyName ASC

--
-- En değerli müşterim hangisi? (en fazla satış yaptığım müşteri) (Gelir ve adet bazında)

select Customers.CompanyName as 'Firma adı',FORMAT(SUM([Order Details].UnitPrice * Quantity * Discount),'C2')as 'Gelir'
from Customers
INNER JOIN Orders ON Orders.CustomerID=Customers.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID=[Order Details].OrderID
GROUP BY Customers.CompanyName
HAVING SUM([Order Details].UnitPrice * Quantity * Discount)=
(select MAX(Gelir)
from (select Customers.CompanyName as 'Firma adı',SUM([Order Details].UnitPrice * Quantity * Discount)as 'Gelir'
	from Customers
	INNER JOIN Orders ON Orders.CustomerID=Customers.CustomerID
	INNER JOIN [Order Details] ON Orders.OrderID=[Order Details].OrderID
	GROUP BY Customers.CompanyName
	) as T)

--
-- Hangi ülkelere ne kadarlık satış yapmışım?

select Orders.ShipCountry,FORMAT(SUM([Order Details].UnitPrice*Quantity*Discount),'C2') as 'Toplam Satış'
from Orders
INNER JOIN [Order Details] ON Orders.OrderID=[Order Details].OrderID
GROUP BY Orders.ShipCountry



SELECT City,Country,COUNT(CompanyName) AS 'Müşeri'
FROM Customers
GROUP BY Country,City