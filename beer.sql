create table Beers (

	name varchar(50),
	manufacturer varchar (50) not null,
	primary key(name)

);

create table Bars (

	name varchar(50),
	addr varchar (50) not null,
	license char(10) not null,
	primary key(name)
);

create table Drinkers (

	name varchar(50),
	addr varchar(50) not null,
	phone integer not null,
	primary key (name)

);

create table Sells (

	price float not null,
	bar varchar(50) references Bars(name),
	beer varchar(50) references Beers(name),
	primary key(bar,beer)

);

create table Likes (

	beer varchar(50) references Beers(name),
	drinker varchar(50) references Drinkers(name)
	primary key(drinker,beer)
);

create table Frequent (

	bar varchar(50) references Bars(name),
	drinker varchar(50) references Drinkers(name)
);