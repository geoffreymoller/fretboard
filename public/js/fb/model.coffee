module 'model'

model.baseScale = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'Bb', 'B'
]

w = 'whole'
h = 'half'
model.modes =
    'ionian':
        intervals: [w,w,h,w,w,w,h]
        shortcut: 'I'
    'dorian':
        intervals: [w,h,w,w,w,h,w]
        shortcut: 'R'
    'phrygian':
        intervals: [h,w,w,w,h,w,w]
        shortcut: 'P'
    'lydian':
        intervals: [w,w,w,h,w,w,h]
        shortcut: 'L'
    'mixolydian':
        intervals: [w,w,h,w,w,h,w]
        shortcut: 'M'
    'aeolian':
        intervals: [w,h,w,w,h,w,w]
        shortcut: 'O'
    'locrian':
        intervals: [h,w,w,h,w,w,w]
        shortcut: 'N'

model.noteNames = [
    #TODO - generate fretboard programatically from tuning
    [ 'E2', 'F2', 'F#2', 'G2', 'G#2', 'A2', 'Bb2', 'B2', 'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'Bb3', 'B3', 'C4', 'C#4', 'D4' ]
    [ 'A2', 'Bb2', 'B2', 'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'Bb3', 'B3', 'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4' ]
    [ 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'Bb3', 'B3', 'C4', 'C#4',  'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'Bb4', 'B4', 'C5' ]
    [ 'G3', 'G#3', 'A3', 'Bb3', 'B3', 'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'Bb4', 'B4', 'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5' ]
    [ 'B3', 'C4', 'C#4',  'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'Bb4', 'B4', 'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5', 'G#5', 'A5' ]
    [ 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'Bb4', 'B4', 'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5', 'G#5', 'A5', 'Bb5', 'B5', 'C6', 'C#6', 'D6' ]
]

