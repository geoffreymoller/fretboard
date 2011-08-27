module 'modules'

modules.staff = class

    constructor: (canvasSelector) ->
        @template = $('<canvas id="vexflowCanvas" width="2000"></canvas>')

    draw: (notes) ->

        STAVE_WIDTH = 1100

        canvasNode =  $("#vexflowCanvas")
        if canvasNode.length
            #TODO - can we instead 
            canvasNode.replaceWith @template.clone()

        @canvas = $("#vexflowCanvas")[0]
        @renderer = new Vex.Flow.Renderer @canvas, Vex.Flow.Renderer.Backends.CANVAS
        @ctx = @renderer.getContext()
        @stave = new Vex.Flow.Stave 10, 0, STAVE_WIDTH
        @stave.addClef("treble").setContext(@ctx).draw()

        generateStaveNote = (note) ->
            if note.indexOf('b') > -1
                return new Vex.Flow.StaveNote({keys: [note], duration: "q"}).addAccidental(0, new Vex.Flow.Accidental("b"))
            else if note.indexOf('#') > -1
                return new Vex.Flow.StaveNote({keys: [note], duration: "q"}).addAccidental(0, new Vex.Flow.Accidental("#"))
            else
                return new Vex.Flow.StaveNote keys: [note], duration: "q"

        notes = (generateStaveNote(note) for note in notes)

        voice = new Vex.Flow.Voice
            num_beats: 17,
            beat_value: 4,
            resolution: Vex.Flow.RESOLUTION

        voice.addTickables notes
        formatter = new Vex.Flow.Formatter().joinVoices([voice]).format([voice], STAVE_WIDTH)
        voice.draw @ctx, @stave

