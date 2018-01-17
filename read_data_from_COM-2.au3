;#include <ButtonConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>
#include <CommMG.au3>

#include <BlockInputEx.au3>

$port = 4
$baud = 9600
$pin = 0

Sleep(80000) ; Задержка перед блокировкой клавиатуры

Func conecta($port,$baud)
	If $baud = "" Then $baud = 9600
	Local $sportSetError
	ConsoleWrite(_CommListPorts(1) &@CRLF)
	_CommSetPort($port, $sportSetError);, $baud, 8, "none",2,1)
	If @error Then
		ConsoleWrite(@error)
		If @error = -16 Then
			MsgBox(0,"","arduino no encontrado en ese puerto =P")
		EndIf
	EndIf
EndFunc

func analogread($pin)
	If $pin < 10 Then $pin = 0&$pin
		_CommSendString("ar"&$pin&@CRLF,1)
		$r = _CommGetLine(@CR,'',300)   ;   было 500
	If $r <> "" Then
		Return $r
	Else
		SetError(1)
	EndIf
EndFunc

Func closesesion()
	_CommClearOutputBuffer()
    _CommClearInputBuffer()
	_CommClosePort()
EndFunc

;$inpcom = _CommGetstring()

conecta($port,$baud)
While 1
	Global $a = 0  ;  Когда колесо остановлено световой сенсор либо получает данные либо нет (перегородка закрывает светодиод или нет),
	Global $b = 0  ;  полученные данные равны либо 0-100 (света нет) либо 3000 - 3200 (свет попадает)
	Global $c = 0  ;  при вращении колеса данные чередуются и если их просуммировать получится среднее значение.
	Global $d = 0  ;  Мы записываем показатели в 9 переменных, складываем их. Если данные меньше 100 или больше 3000 - колесо не вращается,
	Global $e = 0  ;  и клавиатура блокируется.
	Global $f = 0  ;  Есть проблемы: запоздалая реакция при включении клавиатуры,
	Global $g = 0  ;                 при отключении клавиатуры, нажатые кнопки залипают.
	Global $h = 0  ;
	Global $o = 0

	Global $res = 0
	Global $i = 0

	While $i < 8
		If $i = 1 Then
			$a = analogread(0)
		ElseIf $i = 2 Then
			$b = analogread(0)
		ElseIf $i = 3 Then
			$c = analogread(0)
		ElseIf $i = 4 Then
			$d = analogread(0)
		ElseIf $i = 5 Then
			$e = analogread(0)
		ElseIf $i = 6 Then
			$f = analogread(0)
		ElseIf $i = 7 Then
			$g = analogread(0)
		ElseIf $i = 8 Then
			$h = analogread(0)
		ElseIf $i = 9 Then
			$o = analogread(0)
		EndIf
		;Sleep(10)
		$i = $i + 1
	WEnd
	$res = $a+$b+$c+$d+$e+$f+$g+$h+$o

	If $res < 2800 And $res > 900 Then
		;ConsoleWrite('Keyboard Enable'  & @CR)
		_BlockInputEx(0)
	Else
	_BlockInputEx(3)

	EndIf

WEnd
;closesesion()

