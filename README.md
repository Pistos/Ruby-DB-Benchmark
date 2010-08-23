# Ruby Database Benchmark

The goal of this project is to facilitate benchmarking of database access
libraries in the Ruby world.

## Requirements

* Ruby 1.9+
* Rubygems 1.3.7+
* [R](http://www.r-project.org/)
* Several gems (see rdbb.gems)
* PostgreSQL

### Optionals

If you are using [RVM](http://rvm.beginrescueend.com/) (highly recommended),
then you can install all needed gems into a distinct gemset via commands such
as:

    rvm gemset create rdbb
    rvm use 1.9.1@rdbb
    rvm gemset import rdbb.gems

## Execution

    ruby compare.rb --help
    ruby compare.rb <DB lib 1> <DB lib 2> <benchable> [benchable...]

### Example

    ruby compare.rb ActiveRecord RDBI insert_simple

### DB Libraries

* ActiveRecord
* RDBI

Coming soon:

* Sequel
* DataMapper / DataObjects
* Ruby DBI

### Benchables

* insert_simple
* select_simple

## Interpretation

### Example 1

    Set 1 mean: 0.216 s
    Set 1 std dev: 0.023
    Set 2 mean: 0.187 s
    Set 2 std dev: 0.020
    p.value: 0.00287947346770876
    W: 88.0
    The difference (-13.5%) IS statistically significant.

This means that the results permit us to conclude that the second DB library
performs the benchable function 13.5% faster than the first DB library.

### Example 2

    Set 1 mean: 10.968 s
    Set 1 std dev: 4.294
    Set 2 mean: 9.036 s
    Set 2 std dev: 3.581
    p.value: 0.217562623135379
    W: 67.0
    The difference (-17.6%) IS NOT statistically significant.

This means that the results do not permit us to conclude anything; neither
that the first DB library performs faster than the second, nor that the second
performs faster than the first, nor even that they perform equivalently.
