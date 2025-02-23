function venv($dirname){
    #create virtual environment and download packages virtually without affecting local pc
    #eg: uv venv .env
    uv venv $dirname
}

function uvPip($command , $package){
    #install packages using uv which is more faster than pip 
    uv pip $command $package
}
