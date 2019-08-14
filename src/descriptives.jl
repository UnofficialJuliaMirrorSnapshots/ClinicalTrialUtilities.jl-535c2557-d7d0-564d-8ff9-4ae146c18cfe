abstract type AbstractData end
abstract type AbstractDataSet end
"""
    Descriptive statistics type
"""
struct Descriptive <: AbstractData
    var::Union{Symbol, Nothing}
    varname::Union{String, Nothing}
    sortval::Union{Tuple{Vararg{Any}}, Nothing}
    #data::NamedTuple{}
    data::NamedTuple{S,T} where S where T <: Tuple{Vararg{U}} where U <: Real
end
function Base.show(io::IO, obj::Descriptive)
    println(io, "Descriptive statistics")
    for k in keys(obj.data)
        println(io, string(k), " => ", string(obj.data[k]))
    end
end
function Base.getindex(a::Descriptive, s::Symbol)::Real
    return a.data[s]
end
struct DataSet{T <: AbstractData}
    data::Tuple{Vararg{T}}
end
function Base.show(io::IO, obj::DataSet{Descriptive})
    println(io, "Descriptive statistics set")
    for d in obj.data
        print(io, string(d.var), " ")
        if d.sortval !== nothing println(io, "=> ", string(d.sortval)) end
    end
end
function Base.getindex(a::DataSet{Descriptive}, i::Int64)::Descriptive
    return a.data[i]
end
function Base.getindex(a::DataSet{Descriptive}, i::Int64, s::Symbol)::Real
    return a.data[i].data[s]
end
"""
    Descriptive statistics
"""
function descriptive(data::DataFrame;
    sort::Union{Symbol, AbstractArray{T,1}, Nothing} = nothing,
    vars::Union{Symbol, AbstractArray{T,1}},
    stats::Union{Symbol, AbstractVector, Tuple} = :default)::DataSet{Descriptive} where T <: Union{Symbol, String, Int}

    stats = checkstats(stats)

    if isa(vars, Symbol) vars = [vars] end
    if eltype(vars) <: String vars = Symbol.(vars) end

    d = Array{Descriptive, 1}(undef, 0) # Temp Descriptive array
    if sort === nothing
        pushvardescriptive!(d, vars, Matrix(data[:,vars]), nothing, stats)
        return DataSet(Tuple(d))
    end

    if isa(sort, Symbol) sort = [sort] end
    if eltype(sort) <: String sort = Symbol.(sort) end

    sortlist = unique(data[:, sort])
    sort!(sortlist, sort)

    for i = 1:size(sortlist, 1)
        sortval = Tuple(sortlist[i,:])
        mx = getsortedmatrix(data; datacol=vars, sortcol=sort, sortval=sortval)
        pushvardescriptive!(d, vars, mx, sortval, stats)  #push variable descriprives for mx
    end
    return DataSet(Tuple(d))
end
function descriptive(data::Array{T, 1}; stats::Union{Symbol, AbstractVector, Tuple} = :default, var = nothing, varname = nothing, sortval = nothing)::Descriptive where T <: Real
    stats = checkstats(stats)
    return Descriptive(var, varname, sortval, NamedTuple{stats}(Tuple(descriptive_(data, stats))))
end
"""
    Check if all statistics in allstat list. return stats tuple
"""
@inline function checkstats(stats::Union{Symbol, AbstractVector, Tuple})::Tuple{Vararg{Symbol}}
    allstat = (:n, :min, :max, :range, :mean, :var, :sd, :sem, :cv, :harmmean, :geomean, :geovar, :geosd, :geocv, :skew, :ses, :kurt, :sek, :uq, :median, :lq, :iqr, :mode)
    if isa(stats, Symbol)
        if stats == :default stats = (:n, :mean, :sd, :sem, :uq, :median, :lq)
        elseif stats == :all stats = allstat
        else stats = Tuple(stats) end
    end
    stats = Tuple(Symbol.(stats))
    if any(x -> x  ∉  allstat, stats) throw(ArgumentError("stats element not in allstat list")) end
    return stats
end
"""
    Push in d Descriptive obj in mx vardata
"""
@inline function pushvardescriptive!(d::Array{Descriptive, 1}, vars::Array{T, 1}, mx::Union{DataFrame, Matrix}, sortval::Union{Tuple{Vararg{Any}}, Nothing}, stats::Tuple{Vararg{Symbol}}) where T <: Union{Symbol, Int}
    for v  = 1:length(vars)  #For each variable in list
        push!(d, Descriptive(vars[v], nothing, sortval, NamedTuple{stats}(Tuple(descriptive_(mx[:, v], stats)))))
    end
end
"""
    Check if data row sortcol equal sortval
"""
@inline function checksort(data::DataFrame, row::Int, sortcol::Array{Symbol, 1}, sortval::Tuple{Vararg{Any}})::Bool
    for i = 1:length(sortcol)
        if data[row, sortcol[i]] != sortval[i] return false end
    end
    return true
end
"""
    Return matrix of filtered data (datacol) by sortcol with sortval
"""
@inline function getsortedmatrix(data::DataFrame; datacol::Array{T,1}, sortcol::Array{T,1}, sortval::Tuple{Vararg{Any}})::Matrix where T <: Union{Symbol,Int}
    result  = Array{Real, 1}(undef, 0)
    for c = 1:size(data, 1) #For each line in data
        if checksort(data, c, sortcol, sortval)
            for i = 1:length(datacol)
                @inbounds push!(result, data[c, datacol[i]])
            end
        end
    end
    return Matrix(reshape(result, length(datacol), :)')
end



function descriptive_deprecated(data::DataFrame;
    sort::Union{Symbol, Array{T, 1}, Nothing} = nothing,
    vars::Union{Symbol, Array{T, 1},  Nothing} = nothing,
    stats::Union{Symbol, Array{T, 1}} = [:n, :mean, :sd, :sem, :uq, :median, :lq])::DataFrame where T <: Union{Symbol, String}
    #Filtering
    dfnames = names(data) # Col names of dataframe
    #Filter sort
    if isa(sort, Array)
        sort = Symbol.(sort)
        filter!(x->x in dfnames, sort)
        if length(sort) == 0 sort = nothing end
    elseif isa(sort, Symbol)
        if any(x -> x == sort, dfnames)
            sort = [sort]
        else
            sort =  nothing
        end
    else
        sort =  nothing
    end
    #Filters vars
    if isa(vars, Symbol) vars = [vars] end
    if isa(vars, Array)
        vars = Symbol.(vars)
        filter!(x->x in dfnames, vars)
        filter!(x-> !(x in sort), vars)
        if length(vars) > 0
            for i = 1:length(vars)
                if !(eltype(data[:, vars[1]]) <: Real) deleteat!(vars, i) end
            end
        end
        if length(vars) == 0 error("No variables of type Real[] in dataset found! Check vars array!") end
    else
        vars = Array{Symbol,1}(undef, 0)
        for i in dfnames
            if eltype(data[:, i]) <: Real push!(vars, i) end
        end
        if sort !== nothing filter!(x-> !(x in sort), vars) end
        if length(vars) == 0 error("Real[] columns not found!") end
    end
    #Filter statistics array
    if stats == :all
        stats = [:n, :min, :max, :range, :mean, :var, :sd, :sem, :cv, :harmmean, :geomean, :geovar, :geosd, :geocv, :skew, :kurt, :uq, :median, :lq, :iqr, :mode]
    elseif isa(stats, Array)
        stats = Symbol.(stats)
        filter!(x->x in [:n, :min, :max, :range, :mean, :var, :sd, :sem, :cv, :harmmean, :geomean, :geovar, :geosd, :geocv, :skew, :ses, :kurt, :sek, :uq, :median, :lq, :iqr, :mode], stats)
        if length(stats) == 0
            stats = [:n, :mean, :sd, :sem, :uq, :median, :lq]
            @warn "Error in stats, default used."
        end
    else
        stats = [:n, :mean, :sd, :sem, :uq, :median, :lq]
        @warn "Unknown stats, default used."
    end
    #End filtering

    #construct datasets
    dfs   = DataFrame(vars = Symbol[]) #Init DataFrames
    sdata = DataFrame()                #Temp dataset for sorting

    if isa(sort, Array)
        for i in sort                  #if sort - make sort columns in dataset
            dfs[:, i] = eltype(data[:, i])[]
        end
    end
    for i in stats                     #make columns for statistics
        dfs[:, i] = Real[]
    end
    for i in vars                      #var columns for temp dataset
        sdata[:, i] = Real[]
    end
    if !isa(sort, Array)               #if no sort - for vars without sorting
        for v in vars
            sarray = Array{Any,1}(undef, 0)
            deleteat!(data[:, v], findall(x->x === NaN || x === nothing, data[:, v]))
            if length(data[:, v]) > 1
                push!(sarray, v)
                append!(sarray, descriptive_(data[:, v], stats))
                push!(dfs, sarray)
            end
        end
        return dfs
    end

    #If sort exist
    sortlist = unique(data[:, sort])
    sort!(sortlist, tuple(sort))
    for i = 1:size(sortlist, 1) #For each line in sortlist
            if size(sdata, 1) > 0 deleterows!(sdata, 1:size(sdata, 1)) end
            for c = 1:size(data, 1) #For each line in data
                if data[c, sort] == sortlist[i,:]
                    push!(sdata, data[c, vars])  #tmp ds constructing
                end
            end
        for v in vars #For each variable in list
            sarray = Array{Any,1}(undef, 0)
            push!(sarray, v)
            for c in sort
                push!(sarray, sortlist[i, c])
            end
            append!(sarray, descriptive_(sdata[:, v], stats))
            push!(dfs, sarray)
        end
    end
    return dfs
end

#Statistics calculation
@inline function descriptive_(data::Array{T,1}, stats::Union{Tuple{Vararg{Symbol}}, Array{Symbol,1}})::Array{Float64,1} where T <: Real
    deleteat!(data, findall(x->x === NaN || x === nothing || x === missing, data))

    dn         = nothing
    #if (@isdefined dn) end
    dmin       = nothing
    dmax       = nothing
    drange     = nothing
    dmean      = nothing
    dvar       = nothing
    dsd        = nothing
    dsem       = nothing
    dcv        = nothing
    dgeomean   = nothing
    dgeovar    = nothing
    dgeosd     = nothing
    dgeocv     = nothing
    dharmmean  = nothing
    duq        = nothing
    dlq        = nothing
    sesv       = nothing
    sekv       = nothing
    #dirq       = nothing
    #dmode      = nothing
    if length(data) > 0
        sarray = Array{Real,1}(undef, 0)
    elseif length(data) <= 2
        sesv = NaN
        sekv = NaN
    elseif length(data) <= 3
        sekv = NaN
    elseif length(data) == 0
        sarray = Array{Real,1}(undef, length(stats))
        return sarray .= NaN
    end

    if any(x -> (x == :geomean || x == :geocv || x == :geosd || x == :geovar), stats)
        if any(x -> (x <= 0), data)
            dgeomean   = NaN
            dgeovar    = NaN
            dgeosd     = NaN
            dgeocv     = NaN
        else
            logsdata = log.(data)
        end
    end
    for s in stats
        if s == :n
            if dn === nothing dn = length(data) end
            push!(sarray, dn)
        elseif s == :sum
            push!(sarray, sum(data))
        elseif s == :min
            if dmin === nothing dmin = minimum(data) end
            push!(sarray, dmin)
        elseif s == :max
            if dmax === nothing dmax = maximum(data) end
            push!(sarray, dmax)
        elseif s == :range
            if dmax === nothing dmax = max(data) end
            if dmin === nothing dmin = max(data) end
            push!(sarray, abs(dmax-dmin))
        elseif s == :mean
            if dmean === nothing dmean = mean(data) end
            push!(sarray, dmean)
        elseif s == :var
            if dvar === nothing dvar = var(data) end
            push!(sarray, dvar)
        elseif s == :sd
            if dvar === nothing dvar = var(data) end
            if dsd  === nothing dsd  = sqrt(dvar) end
            push!(sarray, dsd)
        elseif s == :sem
            if dvar === nothing dvar = var(data) end
            if dn === nothing dn = length(data) end
            push!(sarray, sqrt(dvar/dn))
        elseif s == :cv
            if dmean === nothing dmean = mean(data) end
            if dvar === nothing dvar = var(data) end
            if dsd  === nothing dsd  = sqrt(dvar) end
            push!(sarray, dsd/dmean*100)
        elseif s == :harmmean
            if dharmmean === nothing
                if any(x -> (x == 0), data)
                    dharmmean = NaN
                else
                    dharmmean = harmmean(data)
                end
            end
            push!(sarray, dharmmean)
        elseif s == :geomean
            if dgeomean === nothing dgeomean = exp(mean(logsdata)) end
            push!(sarray, dgeomean)
        elseif s == :geovar
            if dgeovar === nothing dgeovar = var(logsdata) end
            push!(sarray, dgeovar)
        elseif s == :geosd
            if dgeovar === nothing dgeovar = var(logsdata) end
            if dgeosd === nothing dgeosd = sqrt(dgeovar) end
            push!(sarray, dgeosd)
        elseif s == :geocv
            if dgeovar === nothing dgeovar = var(logsdata) end
            if dgeocv === nothing dgeocv = sqrt(exp(dgeovar)-1)*100 end
            push!(sarray, dgeocv)
        elseif s == :skew
            push!(sarray, skewness(data))
        elseif s == :ses
            if dn === nothing dn = length(data) end
            sesv = ses(dn)
            push!(sarray, sesv)
        elseif s == :kurt
            push!(sarray, kurtosis(data))
        elseif s == :sek
            if dn === nothing dn = length(data) end
            if sesv === nothing sesv = ses(dn) end
            sekv = sek(dn; ses = sesv)
            push!(sarray, sekv)
        elseif s == :uq
            if duq  === nothing duq  = percentile(data, 75) end
            push!(sarray, duq)
        elseif s == :median
            push!(sarray,  median(data))
        elseif s == :lq
            if dlq  === nothing dlq  = percentile(data, 25) end
            push!(sarray, dlq)
        elseif s == :iqr
            if duq  === nothing duq  = percentile(data, 75) end
            if dlq  === nothing dlq  = percentile(data, 25) end
            push!(sarray, abs(duq-dlq))
        elseif s == :mode
            push!(sarray, mode(data))
        end
    end
    return sarray
end

@inline function ses(data::AbstractVector)::Float64
    n = length(data)
    ses(n)
end
@inline function ses(n::Int)::Float64
    return sqrt(6 * n *(n - 1) / ((n - 2) * (n + 1) * (n + 3)))
end

function sek(data::AbstractVector; ses::T = ses(data))::Float64 where T <: Real
    n = length(data)
    sek(n; ses = ses)
end
function sek(n::Int; ses::T = ses(n))::Float64 where T <: Real
    return 2 * ses * sqrt((n * n - 1)/((n - 3) * (n + 5)))
end
