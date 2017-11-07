using MultivariateStats
include("/home/jesus/develop/repos/image-analysis/tools.jl")

function myPCA(x)
    M = PCA
    # pca_ = fit(PCA, x; pratio=0.9)
    pca_ = fit(PCA, x; maxoutdim=4)

    p = principalvars(pca_) / tvar(pca_)
    println("PC explanation: ", p)
    println("PCA %: ", sum(p))

    return projection(pca_)
end

function createMatrix(numFaces = 1521, npts = 20)
    D = 2npts
    myMatrix = zeros(Float64, D, numFaces)

    for i = 1:numFaces
        # 2×20

        pts = openpts(i-1)
        # println(size(pts,1,2))

        ptsMean = mean(pts,2)
        # println(size(ptsMean,1,2))

        ptsMean = repmat(ptsMean, 1, npts)
        # println(size(ptsMean,1,2))
        # error("perro")
        pts -= ptsMean #repmat(ptsMean, 1, npts)
        myMatrix[:,i] = reshape(pts, D)
    end

    return myMatrix
end

function savePTS2csv()
    for i = 0:1520
        println("file num. $i")
        inputName  = @sprintf("points_20/bioid_%04d.pts", i)
        outputName = @sprintf("csv/points_%04d.csv", i)
        
        pts = readcsv(inputName, String);
        pts = pts[4:end-1]
        writecsv(outputName, pts)
    end
end

function opendist(i)
    imname = @sprintf("faces/BioID_%04d.jpg", i)
    fname = @sprintf("csv/points_%04d.csv", i)        
    return imgLoad(imname, 1), readdlm(fname, Float64);
end

function openpts(i)
    fname = @sprintf("csv/points_%04d.csv", i)        
    return readdlm(fname, Float64)';
end

function plotdist(img, pts, mytitle="", mcolor=:b)
    imshow(img, cmap="gray")
    # 2×20
    plot(pts[1,:], pts[2,:], marker=:o, lw=0,markersize=4, color=mcolor)
    title(mytitle)
end

function applyTransform(x, parameters)

    # rotation and scale matrix
    A = [parameters[1] parameters[2];
         parameters[3] parameters[4]]

    # translate vector
    t = [parameters[5]; parameters[6]]

    cols = size(x, 2)
    return A * x + repmat(t, 1, cols)
end

function plotPCA(ptsPCA)
    r, c = size(ptsPCA)

    for i = 1:c
        # i= 2
        pts = reshape(ptsPCA[:,i],20, 2)'
        plot(pts[1,:], pts[2,:], marker=:o, lw=0,markersize=4)
        # break
    end
end