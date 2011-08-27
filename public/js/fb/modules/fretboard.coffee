module 'modules'

modules.fretboard = class

    init: ->

        @Constants =
            CANVAS_OFFSET: 10
            FRETBOARD_LENGTH: 1100
            FRET_COUNT: 22
            FRET_FINGERING_OFFSET: 0
            FRET_STROKE_WIDTH: 2
            FRET_COLOR: '#000'
            NUM_STRINGS: 6
            STRING_COLOR: '#000'
            NUM_INLAYS: 9
            FINGERING_RADIUS: 7
            STROKE_COLOR: '#000'
            FILL_COLOR: '#04a20f'
            ROOT_FILL_COLOR: '#000'

        @Constants.FRETBOARD_WIDTH = @Constants.FRETBOARD_LENGTH / 10
        @Constants.FRET_DISTANCE = @Constants.FRETBOARD_LENGTH / @Constants.FRET_COUNT
        @Constants.STRING_MARGIN = @Constants.FRETBOARD_WIDTH / (@Constants.NUM_STRINGS - 1)
        @Constants.INLAY_RADIUS = @Constants.STRING_MARGIN / 2 - 4
        @Constants.FINGERING_RADIUS = @Constants.STRING_MARGIN / 2 - 2

        canvas = document.getElementById 'myCanvas'
        paper.setup canvas
        paper.view.onFrame = ->

        @fretXCoords = []
        @stringYCoords = []
        @drawStrings()
        @drawFrets()
        @drawInlays()
        paper.view.draw
        @fretboard = @coordinates()
        @

    drawScale: (rootNote, mode) ->
        baseScale =  fb.model.board.baseScale
        rootPosition = $.inArray(rootNote, baseScale)
        baseScale = baseScale[rootPosition..].concat(baseScale[0..rootPosition-1])
        intervals = fb.model.modes[mode].intervals
        notes = []
        index = 0
        notes.push baseScale[0]
        rootNote = notes[0]
        for interval in intervals
            if interval is 'whole'
                index += 2
            else if interval is 'half'
                index += 1
            notes.push baseScale[index] if baseScale[index]

        noteNames = fb.model.board.noteNames
        $.each noteNames, (stringIndex, string) =>
            $.each string, (fretIndex, fret) =>
                note = noteNames[stringIndex][fretIndex]
                note = note.split(/[2-6]/)[0]
                if note in notes
                    coords = @fretboard[stringIndex][fretIndex]
                    circle = new paper.Path.Circle new paper.Point(coords[0] - @Constants.FRET_FINGERING_OFFSET, coords[1]), @Constants.FINGERING_RADIUS
                    circle.strokeColor = @Constants.STROKE_COLOR
                    if note is rootNote
                        circle.fillColor = @Constants.ROOT_FILL_COLOR
                    else
                        circle.fillColor = @Constants.FILL_COLOR

        paper.view.draw

    #TODO
    drawNotes: (params) ->
        x = @fretXCoords
        y = @stringYCoords
        noteNames = fb.model.board.noteNames
        $.each y, (yIndex, yCoordinate) ->
            $.each x, (xIndex, xCoordinate) ->
                circle = paper.circle(xCoordinate - @Constants.FRET_FINGERING_OFFSET, yCoordinate, 9)
                circle.attr fill: '#ccc'
                if params and params.noteNames
                    noteName = noteNames[yIndex][xIndex - 1]
                    t = paper.text(xCoordinate - @Constants.FRET_FINGERING_OFFSET, yCoordinate, noteName)
                    t.attr 'font-size': 8
                    t.attr 'font-weight': 'bold'

    coordinates: ->
        board = []
        x = @fretXCoords
        y = @stringYCoords
        $.each y, (yIndex, yCoordinate) ->
            fingerings = []
            $.each x, (xIndex, xCoordinate) ->
                fingerings.push [xCoordinate, yCoordinate]

            board.push fingerings
        return board

    drawFrets: ->
        xCoord = 1
        fretCount = @Constants.FRET_COUNT + 1
        $.each [1..fretCount], (index, indexValue) =>
            @drawFret xCoord
            @fretXCoords.push xCoord
            xCoord += @Constants.FRET_DISTANCE

    #TODO - clean up offsets
    drawFret: (xCoord) ->
        path = new paper.Path()
        path.strokeColor = @Constants.FRET_COLOR
        path.strokeWidth = @Constants.FRET_STROKE_WIDTH
        path.add new paper.Point xCoord, @Constants.CANVAS_OFFSET
        path.add new paper.Point xCoord, @Constants.FRETBOARD_WIDTH + @Constants.CANVAS_OFFSET

    drawStrings: ->
        yCoord = @Constants.CANVAS_OFFSET
        $.each [1..@Constants.NUM_STRINGS], (index, indexValue) =>
            @drawString yCoord
            @stringYCoords.push yCoord
            yCoord += @Constants.STRING_MARGIN
        @stringYCoords.reverse() #canvas drawn top to bottom; string indexes 0..5 bottom to top

    drawString: (yCoord) ->
        path = new paper.Path()
        path.strokeColor = @Constants.STRING_COLOR
        path.strokeWidth = @Constants.FRET_STROKE_WIDTH
        path.add new paper.Point 0, yCoord
        path.add new paper.Point @Constants.FRETBOARD_LENGTH + @Constants.FRET_STROKE_WIDTH, yCoord

    #TODO - replace with calculated coords from fretXCoords
    drawInlays: ->
        xCoord = (@Constants.FRET_DISTANCE * 3) - (@Constants.FRET_DISTANCE / 2)
        $.each [1..@Constants.NUM_INLAYS], (index, indexValue) =>
            circle = new paper.Path.Circle(new paper.Point(xCoord, (@Constants.FRETBOARD_WIDTH / 2) + @Constants.CANVAS_OFFSET ), @Constants.INLAY_RADIUS)
            circle.fillColor = 'grey'
            circle.strokeColor = 'black'
            if index is 3 or index is 4
                xCoord += @Constants.FRET_DISTANCE * 3
            else
                xCoord += @Constants.FRET_DISTANCE * 2

