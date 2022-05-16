clc
clear
close all

d_x=20;
d_y=20;

enviro=2*(ones(d_x,d_y));

j=0;
x_val = 4;
y_val = 4;
axis([1 d_x+1 1 d_y+1])
grid on;
hold on;
n=0;

xvalue=12;
yvalue=15;
xtar=xvalue;
ytar=yvalue;

enviro(xvalue,yvalue)=0;
plot(xvalue+.5,yvalue+.5,'o');

% writerObj = VideoWriter('ASTAR.avi');
% open(writerObj);


for i = 8:10
    for j = 4:11
        enviro(i,j) = -1; % set obstacles environmental value= -1
    end
end

x = [8, 11, 11, 8];
y = [4, 4, 12, 12];

fill(x,y,'k');

xvalue=3;
yvalue=3;
xini=xvalue;%ini Position
yini=yvalue;%Starting Position

enviro(xvalue,yvalue)=1;
 plot(xvalue+1.5,yvalue+1.5,'bo');
% frame = getframe;
% writeVideo(writerObj,frame);
is_obs=[];

no_obs=[]; 

k=1;
for i=1:d_x
    for j=1:d_y
        if(enviro(i,j) == -1) % check obstacle
            no_obs(k,1)=i; 
            no_obs(k,2)=j; 
            k=k+1;
        end
    end
end
no_obs_size=size(no_obs,1);

pos_x=xini;
pos_y=yini;
isobs_size=1; % initialize size of valid_list
pcost=0;
distance=sqrt((pos_x-xtar)^2 + (pos_y-ytar)^2);

nrow=[1,8];
nrow(1,1)=1;
nrow(1,2)=pos_x;
nrow(1,3)=pos_y;
nrow(1,4)=pos_x; % old x
nrow(1,5)=pos_y; % old y 
nrow(1,6)=pcost;
nrow(1,7)=distance;
nrow(1,8)=distance;

is_obs(isobs_size,:)=nrow; 
is_obs(isobs_size,1)=0;

no_obs_size=no_obs_size+1;
no_obs(no_obs_size,1)=pos_x; 
no_obs(no_obs_size,2)=pos_y;

path_not_found=1;

while((pos_x ~= xtar || pos_y ~= ytar) && path_not_found == 1)
    next=succ(pos_x,pos_y,pcost,xtar,ytar,no_obs,d_x,d_y);
    succ_size=size(next,1);
    for i=1:succ_size
    flag=0;
    for j=1:isobs_size
        if(next(i,1) == is_obs(j,2) && next(i,2) == is_obs(j,3) ) % next same as existing
            is_obs(j,8)=min(is_obs(j,8),next(i,5)); % check for minimum f
            if is_obs(j,8) == next(i,5)
                is_obs(j,4)=pos_x;%
                is_obs(j,5)=pos_y;%
                is_obs(j,6)=next(i,3); %
                is_obs(j,7)=next(i,4); %
            end
            flag=1;
        end
    end
    if flag == 0 % add to path next block with minimum f
        isobs_size= isobs_size+1;
        nrow=[1,8];
        nrow(1,1)=1;
        nrow(1,2)=next(i,1);
        nrow(1,3)=next(i,2);
        nrow(1,4)=pos_x; 
        nrow(1,5)=pos_y; 
        nrow(1,6)=next(i,3); % 
        nrow(1,7)=next(i,4); % 
        nrow(1,8)=next(i,5); % 
        is_obs(isobs_size,:)= nrow;
    end
    end

    nummin = min_f(is_obs,isobs_size,xtar,ytar);
    if (nummin ~= -1) % with obstacle
        pos_x=is_obs(nummin,2);
        pos_y=is_obs(nummin,3);
        pcost=is_obs(nummin,6);

        no_obs_size=no_obs_size+1; %block not chosen
        no_obs(no_obs_size,1)=pos_x;
        no_obs(no_obs_size,2)=pos_y;
        is_obs(nummin,1)=0;
    else
        path_not_found=0;
    end
end
% find path

i=size(no_obs,1);
path=[];
xvalue=no_obs(i,1); %target
yvalue=no_obs(i,2);
i=1;
path(i,1)=xvalue;
path(i,2)=yvalue;
i=i+1;

if ( (xvalue == xtar) && (yvalue == ytar))
    inode=0;
   parent_x=is_obs(find((is_obs(:,2) == xvalue) & (is_obs(:,3) == yvalue),1),4);
   parent_y=is_obs(find((is_obs(:,2) == xvalue) & (is_obs(:,3) == yvalue),1),5);
   
   while( parent_x ~= xini || parent_y ~= yini)
           path(i,1) = parent_x;
           path(i,2) = parent_y;
           
           inode=find((is_obs(:,2) == parent_x) & (is_obs(:,3) == parent_y),1);
           parent_x=is_obs(inode,4);
           parent_y=is_obs(inode,5);
           i=i+1;
   end
%path
j=size(path,1);
 p=plot(path(j,1)+.5,path(j,2)+.5,'bo');
%  frame = getframe;
% writeVideo(writerObj,frame);
  j=j-1;
 for i=j:-1:1
  pause(.25);
  set(p,'XData',path(i,1)+.5,'YData',path(i,2)+.5);
   drawnow ;
 end
% frame = getframe;
% writeVideo(writerObj,frame);

 plot(path(:,1)+.5,path(:,2)+.5);
end
% frame = getframe;
% writerObj=VideoWriter('test.avi', frame);
% open(writerObj);
% close(writerObj);
function successors=succ(x_cell,y_cell,h,x_target,y_target,in_valid,max_x,max_y)
    successors=[];
    successor_count=1;
    ct2=size(in_valid,1);
    for k= 1:-1:-1
        for j= 1:-1:-1
            if (k~=j || k~=0)  %find next
                s_x = x_cell+k;
                s_y = y_cell+j;
                if( (s_x >0 && s_x <=max_x) && (s_y >0 && s_y <=max_y)) % in
                    flag=1;                    
                    for ct1=1:ct2
                        if(s_x == in_valid(ct1,1) && s_y == in_valid(ct1,2)) % next not obstacle or indexed
                            flag=0;
                        end
                    end
                    if (flag == 1)
                        successors(successor_count,1) = s_x;
                        successors(successor_count,2) = s_y;
                        successors(successor_count,3) = h+distance(x_cell,y_cell,s_x,s_y);%h
                        successors(successor_count,4) = distance(x_target,y_target,s_x,s_y);%g
                        successors(successor_count,5) = successors(successor_count,3)+successors(successor_count,4);%f
                        successor_count=successor_count+1;
                    end
                end
            end
        end
    end
end

function index_of_min = min_f(valid,valid_len,x_target,y_target)
%Reference: 26248-a-a-star-search-for-path-planning-tutorial
 temp_array=[];
 k=1;
 flag=0;
 goal_index=0;
 for j=1:valid_len
     if (valid(j,1)==1)
         temp_array(k,:)=[valid(j,:) j]; 
         if (valid(j,2)==x_target && valid(j,3)==y_target)
             flag=1;
             goal_index=j;
         end
         k=k+1;
     end
 end
 if flag == 1 
     index_of_min=goal_index;
 end
 
 if size(temp_array)~= 0
  [min_f,temp_min]=min(temp_array(:,8));
  index_of_min=temp_array(temp_min,9);
 end
end
