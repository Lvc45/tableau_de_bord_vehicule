function generateMsgsDb()
% generateMsgsDb Creates and transmits CAN messages for demo purposes.
%
%   generateMsgsDb periodically transmits multiple CAN messages at various
%   periodic rates with changing message data.
%

% Copyright 2008-2010 The MathWorks, Inc.

    % Access the database file.
    db = canDatabase('tableau_de_bord.dbc');

    % Create the messages to send using the canMessage function.
    msgVehiculeData = canMessage(db, 'VehiculeData'); 
    msgMoteurData = canMessage(db, 'MoteurData');

    % Create a CAN channel on which to transmit.
    txCh = canChannel('MathWorks', 'Virtual 1', 1);

    % Register each message on the channel at a specified periodic rate.
    transmitPeriodic(txCh, msgVehiculeData, 'On', 1);
    transmitPeriodic(txCh, msgMoteurData, 'On', 1);
    
    % Start the CAN channel.
    start(txCh);
    
    % Run for several seconds incrementing the message data regularly.
    for i = 1:20
        % Set new signal data.
        msgVehiculeData.Signals.NiveauCarburant = 48 - 2.75 * i; %>0
        msgVehiculeData.Signals.VitesseVehicule = 50 + (rand * 30);
        % msgVehiculeData.Signals
        msgMoteurData.Signals.MoteurRPM = 4000 + (rand * 2500);
        msgMoteurData.Signals.MoteurTemp = 70 + 3 * i + (rand * 10);
        % msgMoteurData.Signals
        
        % Wait for a time period.
        pause(1);
    end

    % Stop the CAN channel.
    stop(txCh);
end
