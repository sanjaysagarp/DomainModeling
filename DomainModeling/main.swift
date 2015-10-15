//
//  main.swift
//  DomainModeling
//
//  Created by Sanjay Sagar on 10/14/15.
//  Copyright © 2015 Sanjay Sagar. All rights reserved.
//

import Foundation

struct Money {
    var amount: Double;
    var currency: String;
    //var curType: currencyType;
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

class Job {
    var title: String;
    var salary: Double;
    private var hourly: Bool;
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

class Person {
    var firstName: String;
    var lastName: String;
    var age: Int;
    var job: Job?;
    var spouse: Person?;
    
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
        if(self.job == nil && self.spouse == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age)"
        } else if(self.job == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age), \(self.spouse)"
        } else if(self.spouse == nil) {
            return "\(self.firstName), \(self.lastName), \(self.age), \(self.job)"
        }
        return "\(self.firstName), \(self.lastName), \(self.age), \(self.job), \(self.spouse)"
    }
}

class Family {
    var members: [Person] = [];
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
    
    func toString() {
        for person in members {
            print(person.toString());
        }
    }
}
//Testing
var a = Money(amount: 3.0, currency: "USD");

var b = Money(amount: 1.0, currency: "GBP");

print("\(a.amount),\(a.currency)");
a.add(b);
print("\(a.amount),\(a.currency)");
a.subtract(b)
print("\(a.amount),\(a.currency)");

var c = Job(title: "Salesman", salary: 12.20);

var d = Job(title: "Businessman", salary: 71432.12);

print("\(c.title),\(c.salary)");
c.calculateIncome(12);
c.raise(8);
print("\(c.title),\(c.salary)");
print("\(d.title),\(d.salary)");
d.calculateIncome(132);
d.raise(4);
print("\(d.title),\(d.salary)");

var e = Person(firstName: "Bob", lastName: "Being", age: 2);
print(e.toString());

var f = Person(firstName: "Ike", lastName: "Being", age: 23, job: d);
var g = Person(firstName: "Pam", lastName: "Being", age: 26, job: d);

var h = Family(family: [f,g,e]);

print(h.householdIncome());
print(h.toString);
h.haveChild("Billy", lastName: "Being");
print(h.toString);


