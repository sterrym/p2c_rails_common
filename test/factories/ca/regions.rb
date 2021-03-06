Factory.define :region_1, :class => Region, :singleton => true do |c|
  c.id '1'
  c.reg_desc 'Ontario & Maritimes'
  c.country_id '2'
end

Factory.define :region_2, :class => Region, :singleton => true do |c|
  c.id '2'
  c.reg_desc 'Quebec'
  c.country_id '2'
end

Factory.define :region_3, :class => Region, :singleton => true do |c|
  c.id '3'
  c.reg_desc 'Western Canada'
  c.country_id '2'
end

Factory.define :region_4, :class => Region, :singleton => true do |c|
  c.id '4'
  c.reg_desc 'National'
  c.country_id '1'
end

Factory.define :region_5, :class => Region, :singleton => true do |c|
  c.id '5'
  c.reg_desc 'Eastern US'
  c.country_id '1'
end

Factory.define :region_6, :class => Region, :singleton => true do |c|
  c.id '6'
  c.reg_desc 'Western US'
  c.country_id '1'
end
