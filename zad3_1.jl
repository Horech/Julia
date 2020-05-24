using JuMP
using GLPK

m = Model(GLPK.Optimizer)

@variable(m, 0 <= s, Int)
@variable(m, 0 <= l, Int)


sval = 0.4
lval = -0.1

@objective(m, Max, s*sval + l*lval)

@constraint(m, s + l <= 8000)
@constraint(m, 1000 <= l)
@constraint(m, l <= (2.5 * s + 1000))
@constraint(m, s <= 3*l)

optimize!(m)
termination_status(m)

println(m)
println("Wartosc w optymalnym punkcie: ", objective_value(m))
println("Optymalna ilosc SMAK: ", value(s))
println("Optymalna ilosc LASUCH: ", value(l))

#Funkcja celu: Max(wartosc * LASUCH + Wartosc * SMAK)
#Zmienne: opakowanie LASUCH i opakowanie SMAK
#ograniczenia: suma opakowan <= 8000
# LASUCH wiecej opakowan niz 1000
# LASUCH mniej opakowan niz 250%  SMAK +1000
# SMAK nie wiecej niz 3*opakowania LASUCH
#Rozwiazanie: 2000 opakowan LASUCH i 6000 opakowan SMAK
#Omowienie: Minimalizujemy w jak najwiekszym stopniu liczbe opakowan LASUCHA
#maksymalizujac liczbe SMAK. Maksymalny stosunek z podanymi warunkami to 3000
#SMAK na kazde 1000 LASUCHA czyli 2000 LASUCHA i 6000 SMAK aby dobic do limitu
#8000 opakowan
