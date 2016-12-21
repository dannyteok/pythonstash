
hrs = float(raw_input("Enter hours: "))
rateph = float(raw_input("Your hourly rate: "))
grosspay = hrs * rateph

if hrs <= 40.0:
    print grosspay
elif hrs > 40.0:
    grosspay = (40 * rateph) + ((hrs - 40) * (rateph * 1.5) )          # 78.75

    print grosspay