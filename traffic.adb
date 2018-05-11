with Ada.Characters.Latin_1;
with Ada.Numerics.Float_Random;
with Ada.Text_IO;


procedure Traffic is
    type Vehicle_IDs is range 0 .. 9;

    type Number_Plate is access String;

    type Lamp_Color is
        (Red,
         Red_Yellow,
         Green,
         Yellow);

    protected Crossroads is
        entry Cross (Time : Duration);
        procedure Wake_Up;
    end Crossroads;

    protected Multi_Printer is
        entry Init;
        entry Get_Time_To_Cross (Time   :    out Duration;
                                 Offset : in     Duration);
        procedure Print_Lamp_Color (Color : Lamp_Color);
        procedure Print_Vehicle_Status (Plate   : in Number_Plate;
                                        Message : in String);
    private
        G : Ada.Numerics.Float_Random.Generator;
        Initialized : Boolean := False;
    end Multi_Printer;

    protected Lamp is
        function Color return Lamp_Color;
        procedure Switch;
    private
        Curr_Color : Lamp_Color := Red;
    end Lamp;

    task type Signal;
    type Signal_Access is access Signal;

    task Controller is
        entry Stop;
    end Controller;

    task type Vehicle (Plate : Number_Plate);

    task body Vehicle is
        Cross_Duration : Duration;
    begin
        Multi_Printer.Print_Vehicle_Status (Plate, "keresztezodeshez ert");
        Multi_Printer.Get_Time_To_Cross (Cross_Duration, 0.5);
        select
            Crossroads.Cross (Cross_Duration);
        else
            Multi_Printer.Get_Time_To_Cross (Cross_Duration, 2.5);
            Crossroads.Cross (Cross_Duration);
        end select;
        Multi_Printer.Print_Vehicle_Status (Plate, "atert a keresztezodesen " &
                                            Duration'Image (Cross_Time) & " sec alatt.");
        if Vehicle_IDs'Value (Plate.all) = Vehicle_IDs'Last then
            Controller.Stop;
        end if;
    end Vehicle;

    task body Controller is
        Curr_Color : Lamp_Color;
    begin
        loop
            select
                accept Stop;
                exit;
            else
                Curr_Color := Lamp.Color;
                case Curr_Color is
                    when Red | Green => delay 3.0;
                    when Red_Yellow   => delay 1.0;
                    when Yellow      => delay 2.0;
                end case;
                Lamp.Switch;
            end select;
        end loop;
    end Controller;

    task body Signal is
    begin
        Crossroads.Wake_Up;
    end Signal;

    protected body Lamp is
        function Color return Lamp_Color is
        begin
            return Curr_Color;
        end Color;

        procedure Switch is
            S : Signal_Access;
        begin
            if Curr_Color = Lamp_Color'Last then
                Curr_Color := Lamp_Color'First;
            else
                Curr_Color := Lamp_Color'Succ (Curr_Color);
            end if;
            Multi_Printer.Print_Lamp_Color (Curr_Color);
            S := new Signal;
        end Switch;
    end Lamp;

    protected body Multi_Printer is
        entry Init
            when not Initialized is
        begin
            Ada.Numerics.Float_Random.Reset (G);
            Initialized := True;
        end Init;

        entry Get_Time_To_Cross (Time   :    out Duration;
                                 Offset : in     Duration)
            when Initialized is
        begin
            Time := Offset + Duration (Ada.Numerics.Float_Random.Random (G));
        end Get_Time_To_Cross;
        
        procedure Print_Lamp_Color (Color : in Lamp_Color) is
        begin
            Ada.Text_IO.Put_Line ("A lampa: " & Lamp_Color'Image (Color));
        end Print_Lamp_Color;

        procedure Print_Vehicle_Status (Plate   : in Number_Plate;
                                        Message : in String) is
        begin
            Ada.Text_IO.Put_Line (Ada.Characters.Latin_1.HT & Plate.all & " " &
                                  Message);
        end Print_Vehicle_Status;
    end Multi_Printer;

    protected body Crossroads is
        entry Cross (Time : Duration)
            when Lamp.Color = Green is
        begin
            delay Time;
        end Cross;

        procedure Wake_Up is
        begin
            null;
        end Wake_Up;
    end Crossroads;

    V : access Vehicle;
begin
    Multi_Printer.Init;

    for I in Vehicle_IDs'Range loop
        V := new Vehicle (new String'(Vehicle_IDs'Image (I)));
        delay 0.5;
    end loop;
    delay 10.0;
    Controller.Stop;
end Traffic;
