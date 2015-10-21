//
//  main.swift
//  DomainModeling
//
//  Created by Sanjay Sagar on 10/14/15.
//  Copyright © 2015 Sanjay Sagar. All rights reserved.
//

import Foundation

protocol CustomStringConvertible {
    var description : String {get};
}

protocol Mathematics {
    func +(arg1: Self, arg2: Self) -> Self;
    func -(arg1: Self, arg2:  Self) -> Self;
}

extension Double {
    func USD() -> Money {
        return Money(amount: self, currency: "USD")
    }
    func GBP() -> Money {
        return Money(amount: self, currency: "GBP")
    }
    func EUR() -> Money {
        return Money(amount: self, currency: "EUR")
    }
    func CAN() -> Money {
        return Money(amount: self, currency: "CAN")
    }
}

struct Money : CustomStringConvertible, Mathematics {
    var amount: Double;
    var currency: String;
    var description: String {
        return self.currency + String(self.amount);
    }
    
    init(amount: Double = 0.0, currency: String = "USD") {
        self.amount = amount;
        self.currency = currency;
        
    }
    
    mutating func convert(targetCurrency: String) {
        if (self.currency != targetCurrency) {
            if(self.currency == "USD" && targetCurrency == "GBP") {
                self.amount = self.amount / 2;
            } else if(self.currency == "USD" && targetCurrency == "EUR") {
                self.amount = self.amount * 3 / 2;
            } else if(self.currency == "USD" && targetCurrency == "CAN") {
                self.amount = self.amount * 5 / 4;
            } else if(self.currency == "GBP") {
                self.currency = "USD";
                self.amount = 2 * self.amount;
                self.convert(targetCurrency)
            } else if(self.currency == "EUR") {
                self.currency = "USD";
                self.amount = self.amount * 2 / 3;
                self.convert(targetCurrency);
            } else if(self.currency == "CAN") {
                self.currency = "USD";
                self.amount = self.amount * 5 / 4;
                self.convert(targetCurrency);
            }
    
        }
    }
    
    mutating func add(var money: Money) {
        money.convert(self.currency);
        self.amount = self.amount + money.amount;
    }
    
    mutating func subtract(var money: Money) {
        money.convert(self.currency);
        self.amount = self.amount - money.amount;
    }
    
}

func +(left: Money, var right: Money) -> Money {
    if(left.currency != right.currency) {
        right.convert(left.currency);
    }
    return Money(amount: left.amount + right.amount, currency: left.currency);
}
func -(left: Money, var right: Money) -> Money {
    if(left.currency != right.currency) {
        right.convert(left.currency);
    }
    return Money(amount: left.amount - right.amount, currency: left.currency);
}

class Job : CustomStringConvertible {
    var title: String;
    var salary: Double;
    private var hourly: Bool;
    var description: String {
        return "Title: " + self.title + ", " + (self.hourly ? "Hourly wage: $" : "Salary: $") + String(self.salary);
    }
    
    init(title: String, salary: Double, hourly: Bool = false) {
        self.title = title;
        self.salary = salary;
        self.hourly = (salary < 100.0);
    }
    
    func calculateIncome(numHours: Int?) -> Double {
        if(hourly) {
            return Double(numHours!) * salary;
        }
        return salary;
    }
    
    func raise(percent: Double) {
        self.salary = self.salary * (1.0 + (percent / 100.0));
    }
}

class Person : CustomStringConvertible {
    var firstName: String;
    var lastName: String;
    var age: Int;
    var job: Job?;
    var spouse: Person?;
    var description: String {
        if(self.job == nil && self.spouse == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age)";
        } else if(self.job == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age), \(self.spouse!.firstName) \(self.spouse!.lastName)";
        } else if(self.spouse == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age), \(self.job!.title)";
        }
        return "\(self.firstName), \(self.lastName), \(self.age), \(self.job!.title), \(self.spouse!.firstName) \(self.spouse!.lastName)";
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
        if (age > 16) {
            self.job = job;
        }
        if (age > 18) {
            self.spouse = spouse;
        }
    }
    
    func toString() -> String {
        return self.description;
    }
}

class Family : CustomStringConvertible {
    var members: [Person] = [];
    var description: String {
        var result: String = "";
        for person in members {
            result += person.toString() + "\n";
        }
        return result;
    }
    init(family: [Person]) {
        var legal = false;
        for person in family {
            if(person.age > 20) {
                legal = true;
                break
            }
        }
        if(legal) {
            self.members = family;
        }
    }
    
    func householdIncome() -> Double {
        var sum: Double = 0;
        for person in members {
            if(person.job != nil) {
                sum += person.job!.calculateIncome(0);
            }
        }
        return sum;
    }
    
    func haveChild(firstName: String, lastName: String) {
        members.append(Person(firstName: firstName, lastName: lastName, age: 0));
    }
    
    func toString() -> String {
        return self.description;
    }
}


//Testing
var a = Money(amount: 3.0, currency: "USD");

var b = Money(amount: 1.0, currency: "GBP");

print("\(a.amount),\(a.currency)\n");
a.add(b);
print("\(a.amount),\(a.currency)\n");
a.subtract(b)
print("\(a.amount),\(a.currency)\n");

var c = Job(title: "Salesman", salary: 12.20);

var d = Job(title: "Businessman", salary: 71432.12);

print("\(c.title),\(c.salary)\n");
c.calculateIncome(12);
c.raise(8);
print("\(c.title),\(c.salary)\n");
print("\(d.title),\(d.salary)\n");
d.calculateIncome(132);
d.raise(4);
print("\(d.title),\(d.salary)\n");

var e = Person(firstName: "Bob", lastName: "Being", age: 2);
print(e.toString());

var f = Person(firstName: "Ike", lastName: "Being", age: 23, job: d);
var g = Person(firstName: "Pam", lastName: "Being", age: 26, job: d, spouse: f);

var h = Family(family: [f,g,e]);

print(h.householdIncome());
print(h.toString());
h.haveChild("Billy", lastName: "Being");
print(h.toString());

// CustomStringConvertible test

print(a.description);
print(b.description);
print(c.description);
print(d.description);
print(e.description);
print(f.description);
print(g.description);
print(h.description);

// Extension from Double
print(12.0.USD());
print(128.12.CAN());
print(11.23.EUR());
print(433.66.GBP());

// Mathematical Operator tests
print(a + b);
print(b + Money(amount: 1.10, currency: "CAN"));
print(b - a);
print(a - Money(amount: 1.10, currency: "EUR"));