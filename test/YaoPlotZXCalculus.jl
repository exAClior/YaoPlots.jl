using ZXCalculus.ZXW:
    ZXWDiagram, push_gate!, Parameter, match, CalcRule, rewrite!, expval_circ!, stack_zxwd!
using YaoPlots

zxwd = ZXWDiagram(2)

push_gate!(zxwd, Val(:H), 1)
push_gate!(zxwd, Val(:H), 2)
push_gate!(zxwd, Val(:CZ), 1, 2)
push_gate!(zxwd, Val(:X), 1, :a; autoconvert = false)
push_gate!(zxwd, Val(:X), 2, :b; autoconvert = false)

exp_zxwd = expval_circ!(zxwd, "ZZ")
matches = match(CalcRule(:diff, :b), exp_zxwd)
diff_exp = rewrite!(CalcRule(:diff, :b), exp_zxwd, matches)

vizcircuit(diff_exp)

matches = match(CalcRule(:diff, :a), diff_exp)
diff_exp = rewrite!(CalcRule(:diff, :a), diff_exp, matches)
dbdiff_zxwd = stack_zxwd!(diff_exp, copy(diff_exp))

vizcircuit(dbdiff_zxwd)
