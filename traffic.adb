with Ada.Text_IO;


procedure Traffic is
    type Vehicle_IDs is range 0 .. 9;

    type Lamp_Color is
        (Red,
         Red_Yellow,
         Green,
         Yellow);

    protected Lamp is
        function Color return Lamp_Color;
        procedure Switch;
    private
        Curr_Color : Lamp_Color := Red;
    end Lamp;

    task Controller is
        entry Stop;
    end Controller;

    type Number_Plate is access String;

    task type Vehicle (Plate : Number_Plate);

    task body Vehicle is
    begin
        -- Multi_Printer.Print_Vehicle_Status (Plate, "keresztezodeshez ert");
        loop
            if Lamp.Color = Green then
                -- Multi_Printer.Print_Vehicle_Status (Plate, "atert a keresztezodesen");
                null;
            else
                delay 0.2;
            end if;
        end loop;
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

    protected body Lamp is
        function Color return Lamp_Color is
        begin
            return Curr_Color;
        end Color;

        procedure Switch is
        begin
            if Curr_Color = Lamp_Color'Last then
                Curr_Color := Lamp_Color'First;
            else
                Curr_Color := Lamp_Color'Succ (Curr_Color);
            end if;
            -- Multi_Printer.Print_Lamp_Color (Curr_Color);
        end Switch;
    end Lamp;

    V : access Vehicle;
begin
    for I in Vehicle_IDs'Range loop
        V := new Vehicle (new String'(Vehicle_IDs'Image (I)));
        delay 0.5;
    end loop;
    delay 10.0;
    Controller.Stop;
end Traffic;
