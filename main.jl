using Metaheuristics
include("tools.jl")



function myError(parameters, X, ptsPCA, nPCA)
    b = parameters[7:end]
    Y = reshape(ptsPCA * b, 2, 20)

    X_approx = applyTransform(Y, parameters[1:6]) # 2×20
    
    return sum((X - X_approx).^2) / 20 
    # return abs(mean(X_approx) - mean(X)) + abs(std(X_approx) - std(X))
end

function main()
    imTarget = imgLoad("faces/me.jpg")
    ptsTarget= readdlm("csv/me.csv", Float64)

    # imTarget, ptsTarget = opendist(187)
    # read pts and create matrix
    mat_pts = createMatrix()

    # Calculate PCs
    ptsPCA = myPCA(mat_pts)
    nPCA = size(ptsPCA, 2)

    subplot(1,2,1)
    plotPCA(ptsPCA)
 

    X = ptsTarget'

    subplot(1,2,2)
    plotdist(imTarget, X, "Target distribution")

    η   = 5.0
    lims= (-10, 10)
    D   = 6 + nPCA
    nEvals = 20000D

    fitnessFunc(parms) = myError(parms, X, ptsPCA, nPCA)

    nruns = 5

    for _ = 1:nruns
        @time approxParms, ee = eca(fitnessFunc, D; η_max = η,
                                                limits = lims,
                                                termination= x->std(x) < 1e-15,
                                                max_evals  = nEvals,
                                                correctSol=false)
        
        b = approxParms[7:end]
        Y = reshape(ptsPCA * b, 2, 20)
        
        X_approx = applyTransform(Y, approxParms)
        plotdist(imTarget, X_approx, "approx distribution", :r)
        println(approxParms)

    end

    

end

main()