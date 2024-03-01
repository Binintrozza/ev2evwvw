
        local function  checkfile (namefile)
            if isfile(namefile) then
                return true
            end
        end
        local function readingfile(namefile)
            return readfile(namefile)
                
        end
        local function Savefile(namefile,information)
            writefile(namefile,information)
        end
