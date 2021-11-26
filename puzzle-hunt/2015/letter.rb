#!/usr/bin/env ruby

letter = <<LETTER.downcase
9 FPUB_QCB 1357
NSBC WOCB,
O SMHB XOWNPHBCBF EB CHFB PL BYBCFB JPHYSB. GB GOKKBF KBHB O- LBCBF LPC MJ MFX P, _J XBCKOFI! EB OFICBXOBFYW MCB NPHBCY OF EBC RMIJFBW. EB LBCWY YCPYBUMKB OW MF XPDB'W BJ.
EOF,
_MCD
LETTER

from = 'fpub_qcbwoxnhsmlyjikrgd'
to   = 'NOVEMBRESIDCUHAFTYGLPWK'
transform = Hash[from.split(//).zip(to.split(//))]
transform['e'] = 'TH'

puts letter.gsub(/[\w_]/) {|l| transform.fetch(l) { l } }
