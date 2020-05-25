using JuMP
using GLPK

m = Model(GLPK.Optimizer)

@variable(m, 10000 <= Z, Int)
@variable(m, 8000 <= W, Int)
@variable(m, 0 <= S1_Z)
@variable(m, 0 <= S2_Z)
@variable(m, 0 <= S3_Z)
@variable(m, 0 <= S1_W)
@variable(m, 0 <= S2_W)
@variable(m, 0 <= S3_W)

valS1 = -1.2
valS2 = -1.8
valS3 = -2.52
valZ = 3.35
valW = 3.20

@objective(m, Max, Z*valZ + W*valW + (S1_W + S1_Z)*valS1 + (S2_W + S2_Z)*valS2 + (S3_W + S3_Z)*valS3)



@constraint(m, Z == 0.9*W)
@constraint(m, S1_Z <= 0.3*Z)
@constraint(m, S1_W >= 0.25*W)
@constraint(m, S2_Z >= 0.4*Z)
@constraint(m, S2_W <= 0.4*W)
@constraint(m, S3_Z <= 0.2*Z)
@constraint(m, S3_W >= 0.3*W)
@constraint(m, Z == (S1_Z + S2_Z + S3_Z))
@constraint(m, W == (S1_W + S2_W + S3_W))
@constraint(m, S1_Z + S1_W <= 5000)
@constraint(m, S2_Z + S2_W <= 10000)
@constraint(m, S3_Z + S3_W <= 10000)

println(m)
optimize!(m)
println("Optimization status:")
println(termination_status(m))

println("Maksymalna wartosc pieniezna: ", objective_value(m))
println("Optymalna ilosc Benzyny Z: ", value(Z))
println("Optymalna ilosc Benzyny W: ", value(W))
println("Ilosc skladnikow w Benzynie Z: S1: ", value(S1_Z), " S2: ", value(S2_Z), " S3: ", value(S3_Z))
println("Ilosc skladnikow w Benzynie W: S1: ", value(S1_W), " S2: ", value(S2_W), " S3: ", value(S3_W))

#Funkcja celu: max z wartosci bezyn * ilosc kazdej benzyny - koszta skladnikow
#Zmienne: Ilosc Benzyny Z i W oraz poszczegolne skladniki(S1/2/3) w benzynie Z i W
#ograniczenia: Stosunek benzyny Z do W jak 9:10 oraz ilosci skladnikow
#poszczegolnych benzyn nie przekraczajace % benzyny na ktora sie skladaja
#(podane w tabelce, nie ma sensu ich wypisywac tutaj osobno)
#rozwiązanie: Powinno się wyprodukować 11835 ton benzyny Z skladajacej sie z
# 1712.5 tony S1, 10000 ton S2 oraz 122.5 tony S3
#Oraz 13150 ton benzyny W skladajacej sie z:
# 3287.5 tony S1 i 9862.5 tony S3
#Omowienie wynikow:
#Z dokonanej analizy wynika ze benzyna W nie powinna zawierac skladnika S2
#Benzyna Z powinna sie skladac z jak najwiekszej ilosci skladnika S2
#Jako ze jest to najdrozszy skladnik a benzyny Z musimy wyprodukować mniej
#Minimalizujemy koszt produkcji benzyny W jako ze mozemy jej wyprodukowac najwiecej
#a wiec chcemy zeby byl z niej jak najwiekszy zysk na tone.
