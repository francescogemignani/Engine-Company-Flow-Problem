#Engine Company nodes
set Company;

#Subset of plant nodes
set Plants within (Company);

#Subset of warehouse nodes
set Warehouses within (Company);

#Subset of distributor nodes
set Distributors within (Company);

#List of directed arcs that compone the entire graph 
set Link within (Company cross Company);

#Subset of links from plants to warehouses
set PlantLink within (Link);

#Subset of capacitated links
set CapacitatedLink within (Link);

#Link costs
param Costs{Link};

#Engine production cost for each plant
param ProductionCosts{Plants};

#Capacities and demands for each node
param DemSup{Company};

# Decision Variable (not negative)
var Ship{Link} >= 0;

# Objective function that minimize the total cost, composed of the production cost plus the transport cost
minimize Total_Cost: sum{(i,j) in PlantLink} ProductionCosts[i] * Ship[i,j] + sum{(i,j) in Link} Costs[i,j] * Ship[i,j];

#Plant capacity constraints
subject to Supply {i in Plants}: -sum {(i,k) in Link} Ship[i,k]>=DemSup[i];

#Warehouse flow conservation constraints (demand equal to 0)
subject to Transshipment {i in Warehouses}: sum {(j,i) in Link} Ship[j,i] - sum{(i,k) in Link} Ship[i,k] == DemSup[i];

#Distributors demand constraints
subject to Demand {i in Distributors}: sum {(j,i) in Link} Ship[j,i] - sum{(i,k) in Link} Ship[i,k] == DemSup[i];

#Plants minimum production constraints
subject to SupplyMinProd {i in Plants}: sum{(i,k) in Link} Ship[i,k]>=150;

#Warehouses Process Capacities
subject to TransshipmentCap {i in Warehouses}: sum{(j,i) in Link} Ship[j,i] <= 500;

#Link from Warehouse 2 to Distributor 1 has capacity less or equal to 250
subject to LinkCap {(i,j) in CapacitatedLink}: Ship[i,j] <= 250;

