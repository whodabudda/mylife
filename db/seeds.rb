# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
units = Unit.create([
					{name: 'Millimeters', displ_name: 'mm',duser_id: 1},
					{name: 'Centimeters', displ_name: 'cm',duser_id: 1},
					{name: 'Cubic Centimeters', displ_name: 'cc',duser_id: 1},
					{name: 'Blood Glucose', displ_name: 'ug',duser_id: 2}
					])

duser_metrics = DuserMetric.create ([
	{value: 150 , occur_dttm: DateTime.parse("2015-10-25 16:55:00"),duser_id: 1,metric_id:	1},
	{value: 90 , occur_dttm:  DateTime.parse("2015-10-25 16:55:00"),duser_id: 1,metric_id:	2},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 17:55:00"),duser_id: 1,metric_id:	1},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 17:55:00"),duser_id: 1,metric_id:	2},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 18:55:00"),duser_id: 1,metric_id:	1},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 18:55:00"),duser_id: 1,metric_id:	2},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 19:55:00"),duser_id: 1,metric_id:	1},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 19:55:00"),duser_id: 1,metric_id:	2},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 20:55:00"),duser_id: 1,metric_id:	1},
	{value: 150 , occur_dttm:  DateTime.parse("2015-10-25 20:55:00"),duser_id: 1,metric_id:	2}
 ])