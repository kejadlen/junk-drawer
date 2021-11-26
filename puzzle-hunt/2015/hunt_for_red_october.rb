#!/usr/bin/env ruby

require 'pry'

novels = <<NOVELS.chomp.gsub(' ', '').split("\n")
red storm rising
the cardinal of the kremlin
dead or alive
without remorse
clear and present danger
against all enemies
command authority
locked on
debt of honor
NOVELS

ssn = '438592816'.split(//).map(&:to_i)

p novels.zip(ssn).map {|n,i| n[i-1] }.join
p novels.zip(ssn).map {|n,i| n[n.size-i] }.join

p novels.sort.zip(ssn).map {|n,i| n[i-1] }.join
p novels.sort.zip(ssn).map {|n,i| n[n.size-i] }.join

p novels.sort.reverse.zip(ssn).map {|n,i| n[i-1] }.join
p novels.sort.reverse.zip(ssn).map {|n,i| n[n.size-i] }.join

p novels.reverse.zip(ssn).map {|n,i| n[i-1] }.join
p novels.reverse.zip(ssn).map {|n,i| n[n.size-i] }.join
