"
I'm a CodeSmellDetector thar detects code smell of too many lines in a method.
"
Class {
	#name : #CSDetectorTooManyLinesInMethod,
	#superclass : #CodeSmellDetector,
	#instVars : [
		'methodBodyMaxlength',
		'tooManyLinesMethods'
	],
	#category : #CSharpASTAnalysis
}

{ #category : #initialization }
CSDetectorTooManyLinesInMethod >> initialize [
	tooManyLinesMethods := Dictionary new.
	methodBodyMaxlength := 10.
]

{ #category : #initialization }
CSDetectorTooManyLinesInMethod >> initializeCollections [
	tooManyLinesMethods := Dictionary new.
]

{ #category : #accessing }
CSDetectorTooManyLinesInMethod >> methodBodyMaxlength [
	^ methodBodyMaxlength
]

{ #category : #accessing }
CSDetectorTooManyLinesInMethod >> methodBodyMaxlength: anObject [
	methodBodyMaxlength := anObject
]

{ #category : #private }
CSDetectorTooManyLinesInMethod >> printResult [
	| text report |
	report := CodeSmellReport new.
	report name: (self printString). 
	text := WriteStream on: ''.
	tooManyLinesMethods keysAndValuesDo: [ :method :lines | 
						report csClassName: method parent name value.
						text nextPutAll: method header name value;
						nextPutAll: ' method has too many lines, with: ';
						nextPutAll: lines printString;
						nextPutAll: ' lines'.
						report addDetection: text.
			].
	^ report.
]

{ #category : #printing }
CSDetectorTooManyLinesInMethod >> printString [
	^ 'Too Many Lines in Method'
]

{ #category : #visitor }
CSDetectorTooManyLinesInMethod >> visitBlockStatement: aBlockStatement [
	| lines |
	lines := aBlockStatement statements size.
	(lines > methodBodyMaxlength)
		ifTrue: [ tooManyLinesMethods at: (aBlockStatement parent parent) put: lines ]
]