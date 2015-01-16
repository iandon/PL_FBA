function drawPreCue(loc)
    global stimulus
    
    if stimulus.preCue.type == 0
        if stimulus.oriType == 1
            mglLines2(stimulus.respCueOri{1}(1), stimulus.respCueOri{1}(3),...
                      stimulus.respCueOri{1}(2), stimulus.respCueOri{1}(4), stimulus.respCue.width,stimulus.black);
            mglLines2(stimulus.respCueOri{2}(1), stimulus.respCueOri{2}(3),...
                      stimulus.respCueOri{2}(2), stimulus.respCueOri{2}(4), stimulus.respCue.width,stimulus.black);
        elseif stimulus.oriType == 2
            mglLines2(stimulus.respCueOri{3}(1), stimulus.respCueOri{3}(3),...
                      stimulus.respCueOri{3}(2), stimulus.respCueOri{3}(4), stimulus.respCue.width,stimulus.black);
            mglLines2(stimulus.respCueOri{4}(1), stimulus.respCueOri{4}(3),...
                      stimulus.respCueOri{4}(2), stimulus.respCueOri{4}(4), stimulus.respCue.width,stimulus.black);
        end
    elseif stimulus.preCue.type == 1
        mglLines2(stimulus.respCueOri{loc}(1), stimulus.respCueOri{loc}(3),...
                  stimulus.respCueOri{loc}(2), stimulus.respCueOri{loc}(4), stimulus.respCue.width,stimulus.black);
    end

end