# Copyright 2013 Naga Vijayapuram
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# bornin method - spots the class/module where the method was born
#
def bornin _method, _class=[Fixnum,Float,String,Array,Hash,Range,Regexp]

  # the patten to grep for
  re = Regexp.new '^' + _method.to_s + '$'

  # to colorize output
  require 'colorize'

  # born in BasicObject?
  if BasicObject.instance_methods(false).grep(re).size==1
    return puts "=> #{_method} : " +
      ". born in BasicObject as an instance method".green
  # born in Kernel?
  elsif Kernel.instance_methods(false).grep(re).size==1
    return puts "=> #{_method} : " +
      ".. born in Kernel as an instance method".green
  # born in Object?
  elsif Object.instance_methods(false).grep(re).size==1
    return puts "=> #{_method} : " +
      "... born in Object as an instance method".green
  # born in Module?
  elsif Module.instance_methods(false).grep(re).size==1
    return puts "=> #{_method} : " +
      ".... born in Module as an instance method".green
  end

  # puts "check what class is _class"
  # check what class is _class
  if _class.class == String
    _class = eval(_class)
  elsif _class.class == Symbol
    _class = Kernel.const_get(_class.to_s)
    # relying on some very basic classes listed above when
    # _class was not passed as a param
  elsif _class.is_a? Array
    _class.each do |e|
      # puts "Checking #{_method} in #{e} ..."
      output = bornin2 _method, e
      output || break
      # return
    end
  else
    bornin2 _method, _class
  end

end # bornin

#
# bornin2 - scan ancestors
#
def bornin2 _method, _class

  # the patten to grep for
  re = Regexp.new '^' + _method.to_s + '$'

  _class.ancestors.each do |ancestor|

    #- in methods?
    if ancestor.methods(false).grep(re).size==1
      return puts "=> #{_method} : " +
	"..... born in #{ancestor} as a method".green
    end

    #- in instance_methods?
    if ancestor.instance_methods(false).grep(re).size==1
      return puts "=> #{_method} : " +
	"...... born in #{ancestor} as an instance method".green
    end

  end # scanning ancestors

end # bornin2

# ------------------------------------
# Test
# ------------------------------------
# bornin 'p'
# bornin 'puts'
# bornin 'class_eval'
# bornin 'module_eval'
# bornin 'instance_eval'
# bornin 'join'
# ------------------------------------
# bornin 'p', String
# bornin 'puts', String
# bornin 'class_eval', String
# bornin 'module_eval', String
# bornin 'instance_eval', String
# bornin 'join', Array
# ------------------------------------
